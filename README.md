# あなたのRailsアプリはいくら？
このプロジェクトは暇だったので作ってみたRailsプロジェクトに値段をつけるアプリです。  
値段のつけ方は適当なので、お遊びにしか使えませんw

間違ってもこのアプリを報酬で使わないようにしてください。

※注意
当然ですが、サービスによる付加価値などは一切考慮してません！！

## 概要
このプログラムはRailsプロジェクトのステップ数やコードの書き方によって適当に値段をつけていきます。
値段は`円`のみの対応となります。

RubyやRailsの構文に関してはある程度考慮してますが、基本的にはステップ数のみが対応となってます。


## 使い方
Railsのルートパスを引数として渡すとそのプロジェクトの値段が算出されます。

```sh
$ ruby how_much.rb rails_root_path [output_folder]
Welcome to joke app!
Your Rails app will be 613,370 yen
During the reporting ...
Report is here > ~/how_much_your_rails_app/output/index.html
```

以下でヘルプを見れます。

```sh
$ ruby how_much.rb -h/--help
```

### output_folder
指定をしない場合は本プロジェクト内に作成されます。

## 製作日数
1日
惰性で作った感が半端ないw