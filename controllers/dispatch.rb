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
      # 対象ファイルに対して値段をつけます。
      puts "#{rails_path}:#{file_name}"
    end
  end

  private

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