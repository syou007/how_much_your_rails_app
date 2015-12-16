# 指定のファイルを読み込みます。
class LoadFile
  # 指定パス内のrubyファイルを全て読み込みます。
  def self.path(path)
    Dir[File.expand_path("../../#{path}", __FILE__) << '/*.rb'].each do |file|
      require file
    end
  end
end