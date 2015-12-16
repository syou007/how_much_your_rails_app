# Rubyプログラムを解析します。
class RubyProgram < Program

  # rubyの設定を読み込む
  config_file :ruby

  private

  # 制御構文であるか？
  def proc_line?(line)
    (/^.*(if\s|for\s|while\s|\.each|\.times).*$/ =~ line) != nil
  end

end