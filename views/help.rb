# ヘルプを表示するためだけのクラスです。
class Help
  def self.show
    puts <<"EOS"
How much your Rails app?
This will calculate the price of your Rails project.

  Usage:
    ruby how_much.rb -h/--help
    ruby how_much.rb rails_root_path [output_folder]

  Examples:
    ruby how_much.rb ~/rails_project
    ruby how_much.rb ~/rails_project ~/output_path

EOS
  end
end