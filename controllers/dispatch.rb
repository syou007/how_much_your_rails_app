# 各ファイルへアクセスするためのディスパッチクラスです。
class Dispatch
  # 初期設定を行います。
  def initialize(rails_path, output_path)
    @rails_path = rails_path
    @output_path = output_path
  end

  # 実際に値段を算出します。
  def run
    # 値段の初期設定
    price = 0

    # 全てのファイルを読み込みます。
    read_all_file do |rails_path, file_name|
      # パーサーモデルを取得します。
      model = get_parser_model(rails_path, file_name)
      if model
        Logger.debug "[Start]   #{file_name}"

        # インスタンスを生成して実行します。
        instance = model.new("#{@rails_path}#{rails_path}/#{file_name}")
        instance.price_calculation
        price += instance.price

        # TODO 出力ページの作成

        Logger.debug "[End]   #{file_name}"
      else
        Logger.debug "[Skip]   #{file_name}"
      end
    end

    Logger.info "Your Rails app will be #{price} yen"
  end

  private

  # 使用するパーサーモデルを取得
  def get_parser_model(rails_path, file_name)
    # 指定のモデルを取得します。
    if File::extname(file_name) == ".rb"
      # Rubyのパーサーを返します。
      return RubyProgram
    end

    # 使用するモデルなし。
    nil
  end

  # 再帰的に全てのフォルダを読み込みます。
  def read_all_file(current_path = "", &block)
    # ディレクトリを読み込みます。
    Dir.foreach("#{@rails_path}/#{current_path}") do |file|
      # 不要なディレクトリはスキップ
      next if file == "." || file == ".."

      if FileTest::directory? "#{@rails_path}#{current_path}/#{file}"
        # 対象外のフォルダの場合はスキップする。
        next if AppConfig.get(:base, :ignore_dir).include?(file)

        # ディレクトリの場合は再起する。
        read_all_file("#{current_path}/#{file}") do |rails_path, file_name|
          # ファイルの場合はコールバックを呼び出す。
          block.call("#{rails_path}", file_name)
        end
      else
        # ファイルの場合はコールバックを呼び出す。
        block.call("#{current_path}", file)
      end
    end
  end
end