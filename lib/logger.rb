# 簡易ログクラス
class Logger
  # 通常メッセージ
  def self.info(msg)
    puts msg
  end

  # デバッグ時のメッセージ
  def self.debug(msg)
    puts msg if AppConfig.get(:base, :debug)
  end
end