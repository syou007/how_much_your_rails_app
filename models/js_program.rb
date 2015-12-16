class JsProgram < Program

  # jsの設定を読み込む
  config_file :js

  private

  # メソッド開始であるか？
  def method_start_line?(line)
    return false if method_end_line?(line)
    (/^.*(function\s|{).*$/ =~ line) != nil
  end

  # メソッド終了であるか？
  def method_end_line?(line)
    (/^.*(}).*$/ =~ line) != nil
  end

  # コメント行であるか？
  # 複数行コメントはきついので未対応
  def comment_line?(line)
    line.index("//") == 0
  end

end