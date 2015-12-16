# 検査系の処理をまとめてます。
class Validate
  # 指定のフォルダが存在しているかチェック
  def self.dir?(path)
    FileTest::directory? path
  end

  # Railsプロジェクトであるか簡易的にチェック
  def self.rails_project?(path)
    # 条件に当てはまるカウントを調べる。
    rails_project_check_count = 0

    # ディレクトリ内をチェックします。
    Dir.foreach(path) do |file|
      # config.ruが存在するか？
      rails_project_check_count += 1 if file == "config.ru"

      # config内部をチェックする。
      if file == "config"
        Dir.foreach("#{path}/#{file}") do |f|
          # 各ファイルが存在するか？
          rails_project_check_count += 1 if f == "application.rb"
          rails_project_check_count += 1 if f == "boot.rb"
          rails_project_check_count += 1 if f == "routes.rb"
          rails_project_check_count += 1 if f == "environment.rb"
        end
      end
    end

    rails_project_check_count == 5
  end
end