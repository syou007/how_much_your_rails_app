class MigrateProgram < Program

  # Migrateの設定を読み込む
  config_file :migrate

  private

  # インデックスを制御構文扱いにする。
  def proc_line?(line)
    line.index("add_index") == 0
  end

end