# アプリケーションの設定ファイルを読み込みます。
class AppConfig
  # yamlを使用
  require 'yaml'

  # データを取得します。
  def self.get(*keys)
    yml = AppConfig.yml["app"]
    keys.each { |key|
      yml = yml[key.to_s]
    }
    # 中身を書き換えられないようにコピーを渡す。
    return yml.dup
  end

  private

  # ymlデータを取得します。
  def self.yml
    # yamlファイルを取得
    @@yaml ||= YAML.load_file(File.expand_path("../../config/app.yml", __FILE__))
  end
end