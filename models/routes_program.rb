class RoutesProgram < Program

  # Migrateの設定を読み込む
  config_file :migrate

  private

  # resourcesを制御構文扱いにする。
  def proc_line?(line)
    line.index("resources") == 0
  end
end