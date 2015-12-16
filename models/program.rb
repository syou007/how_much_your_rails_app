# このクラスを基底にしてプログラムの値段を算出します。
class Program
  # 値段、メソッドの行数、メソッド行数を超えているカウント、制御プログラムの行数、通常プログラムの行数、コメントの行数、無効行
  attr_accessor :price, :method_count, :method_line_over_count, :proc_line_count,
                :line_count, :comment_count, :invalid_line_count

  # レポート出力で使用
  attr_accessor :path, :file_name

  # 使用する設定ファイルの定義
  def self.config_file(symbol)
    define_method(:config_file) {
      @config ||= AppConfig.get(:program, symbol)
    }
  end
  config_file :base

  # ファイルパスを起点に処理を行います。
  def initialize(rails_path, path, file_name)
    # 基底の設定ファイルを読み込み
    @base_config = AppConfig.get(:program, :base)
    # ファイルパスを保持
    self.path = path
    self.file_name = file_name
    @file_path = "#{rails_path}#{path}/#{file_name}"

    # 各種設定初期化
    self.method_count = 0
    self.method_line_over_count = 0
    self.proc_line_count = 0
    self.line_count = 0
    self.comment_count = 0
    self.invalid_line_count = 0

    # 内部変数初期化

    # メソッド内に入っている数
    @method_incremental_count = 0
    # メソッド内のプログラム行数
    @method_line_count = 0
  end

  # 値段を算出します。
  def price_calculation
    # 基本の値段算出
    self.price = file_price

    # ファイルを読み込んで値段を算出する。
    open(@file_path) { |file|
      # 行単位で処理を行う。
      file.each_line do |line|
        # 前後の空白を削除
        l = line.strip
        # 空行は無視
        next if l.length == 0

        if comment_line?(l)
          # コメントの値段
          self.price += comment_line_price
          self.comment_count += 1
        else
          # プログラム構文解析

          # 現在メソッド内にいるか？
          if @method_incremental_count > 0
            @method_line_count += 1
            # 行数がオーバーしている場合
            if @method_line_count > method_max_line
              self.method_line_over_count += 1
              self.price += method_line_over_price
            end
          else
            @method_line_count = 0
          end

          if method_start_line?(l)
            # メソッド開始
            @method_incremental_count += 1
            self.method_count += 1
            self.price += method_price
          elsif method_end_line?(l)
            # メソッド終了
            @method_incremental_count -= 1
          elsif proc_line?(l)
            # 制御構文の値段
            self.price += proc_line_price
            self.proc_line_count += 1
          elsif invalid_line?(l)
            # この行は無効カウントとする。
            self.invalid_line_count += 0
          else
            # 通常行の値段
            self.price += line_price
            self.line_count += 1
          end
        end
      end
    }
  end

  private

  # 追加で行いたい処理
  def price_calculation_ext(line)
    # 必要に応じて継承先で実装する。
  end

  #
  # 制御処理
  #

  # メソッド開始であるか？
  def method_start_line?(line)
    # この行でメソッドが閉じている場合は開始してたとしても無効
    # ex) 5.times { |i| p i }
    return false if method_end_line?(line)
    (/^.*(def\s|{).*$/ =~ line) != nil
  end

  # メソッド終了であるか？
  def method_end_line?(line)
    (/^.*(end|}).*$/ =~ line) != nil
  end

  # メソッド数オーバー
  def method_max_line
    config(:method, :max_line)
  end

  # 制御構文であるか？
  def proc_line?(line)
    (/^.*(if\s|for\s|while\s).*$/ =~ line) != nil
  end

  # コメント行であるか？
  def comment_line?(line)
    line.index("#") == 0
  end

  # 無効カウントとする行であるか？
  def invalid_line?(line)
    line == "end" || line == "}"
  end

  #
  # 値段
  #

  # ファイルの値段
  def file_price
    @file_price ||= config(:file_price)
  end

  # メソッドの値段
  def method_price
    @method_price ||= config(:method, :price)
  end

  # メソッドの値段
  def method_line_over_price
    @method_line_over_price ||= config(:method, :max_line_over_price)
  end

  # 制御構文の値段
  def proc_line_price
    @proc_line_price ||= config(:line, :proc_line_price)
  end

  # 通常のラインの値段
  def line_price
    @line_price ||= config(:line, :line_price)
  end

  # コメントの値段
  def comment_line_price
    @comment_line_price ||= config(:line, :comment_line_price)
  end

  # 使用する設定内容を取得ます。
  def config(*keys)
    # 使用する設定を取得
    config = config_file
    base_config = @base_config

    # 設定がない場合はbaseを引き継ぐ
    config = base_config if config.nil?
    keys.each { |key|
      config = config[key.to_s]
      base_config = base_config[key.to_s]
      config = base_config if config.nil?
    }

    config
  end
end