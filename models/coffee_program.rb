class CoffeeProgram < Program

  # CoffeeScriptの設定を読み込む
  config_file :coffee

  private

  # CoffeeScriptの構文解析は辛いのでメソッド扱いはしない。
  def method_start_line?(line)
    false
  end

  def method_end_line?(line)
    false
  end

  # ファンクションを制御構文扱いにする。
  def proc_line?(line)
    func_proc = line.index("->")
    func_proc && func_proc > 0
  end

end