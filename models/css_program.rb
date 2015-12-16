class CssProgram < Program

  # CoffeeScriptの設定を読み込む
  config_file :css

  private

  # CSSではメソッドはない。
  def method_start_line?(line)
    false
  end

  def method_end_line?(line)
    false
  end

  # CSSでは特殊構文はない。
  def proc_line?(line)
    false
  end

end