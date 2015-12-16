# このクラスを基底にしてプログラムの値段を算出します。
class Program
  # 値段
  attr_accessor :price

  # 使用する設定ファイルの定義
  def self.config_file(symbol)
    define_method(:config_file) {
      @config ||= AppConfig.get(:program, symbol)
    }
  end
  config_file :base

  # ファイルパスを起点に処理を行います。
  def initialize(file_path)
    # 基底の設定ファイルを読み込み
    @base_config = AppConfig.get(:program, :base)
    # ファイルパスを保持
    @file_path = file_path
  end

  # 値段を算出します。
  def price_calculation
    # 値段の初期化
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
        else
          # プログラム構文解析

          if proc_line?(l)
            # 制御構文の値段
            self.price += proc_line_price
          else
            # 通常行の値段
            self.price += line_price
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

  # メソッドであるか？

  # 制御構文であるか？
  def proc_line?(line)
    (/^.*(if\s|for\s|while\s).*$/ =~ line) != nil
  end

  # コメント行であるか？
  def comment_line?(line)
    line.index("#") == 0
  end

  #
  # 値段
  #

  # ファイルの値段
  def file_price
    @file_price ||= config(:file_price)
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