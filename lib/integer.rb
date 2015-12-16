class Integer
  # http://qiita.com/Katsumata_RYO/items/1055c2f27cbd99e67fc2
  def jpy_comma
    self.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
  end
end