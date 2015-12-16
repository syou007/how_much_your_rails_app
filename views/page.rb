# HTMLページを作成します。
class Page
  require 'erb'
  require 'fileutils'

  # インデックスページを作成します。
  def self.create_index(output_path, price, programs)
    # ERBファイルを読み込む
    erb = ERB.new(File.read(File.expand_path("../../template/index.html.erb", __FILE__)))

    File.write("#{output_path}/index.html", erb.result(binding))

    # 整形用にBootstrapをコピーする。
    FileUtils.cp(File.expand_path("../../template/bootstrap.min.css", __FILE__), "#{output_path}/bootstrap.min.css")

    # 作成したパスを返却する。
    "#{output_path}/index.html"
  end
end