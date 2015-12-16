#!/usr/bin/ruby

# 必要なファイルを読み込みます。
# $:.unshift File.dirname(__FILE__)
require_relative 'lib/load_file'
LoadFile.path 'controllers'
LoadFile.path 'views'
LoadFile.path 'models'
LoadFile.path 'lib'

# 起動確認用に表示
Logger.info "Welcome to joke app!"

# ヘルプの表示
if !ARGV[0] || ARGV[0] == "-h" || ARGV[0] == "--help"
  # ヘルプの表示
  Help.show
else
  # Railsのプロジェクトパスを取得
  # パスの最後に"/"がある場合は取り除く
  rails_path = ARGV[0].gsub(/\/$/, "")

  # 出力先フォルダの取得
  # パスの最後に"/"がある場合は取り除く
  output_path = (ARGV[1] || File.expand_path("../output", __FILE__)).gsub(/\/$/, "")

  # 対象のフォルダが存在するかチェック
  unless Validate.dir? rails_path
    Logger.info "rails project path is not found. => #{rails_path}"
    exit 1
  end

  # 出力フォルダが存在するかチェック
  unless Validate.dir? output_path
    Logger.info "output path is not found. => #{output_path}"
    exit 1
  end

  # Railsプロジェクトであるかチェック
  unless Validate.rails_project? rails_path
    Logger.info "`#{rails_path}` path is not rails project."
    exit 1
  end

  # dispatchに受け渡す。
  Dispatch.new(rails_path, output_path).run
end