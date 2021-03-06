# alarm2022

2022年ハッカソンでつくったアラームアプリ

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## gitを使う際にすること

windowsの人はローカルのgitは`git config --global core.autocrlf input`をしておいてください。git リポジトリ内にCRLFのファイルが混ざるのを防ぎます。

新しい作業を行うときはissueを立ててmainブランチから`feature/#1-create-ui`のように`feature/#{issue番号}-{説明(最悪なくても可)}`の命名則でブランチを生やしてください。作業が終わったらpushしてmainブランチへpull requestを出しておいてください。他の人に見てもらってからマージします。<span style="color:red;">**決してローカルでmainブランチにマージしないでください**</span>。
コミットメッセージやissueの内容は日本語でいいです

## フォーマット

コードはpushする前に必ずフォーマットしてください。Android Studioでのショートカットはctrl+alt+lでvscodeではalt+shit+fまたは、保存時のフォーマットを有効にしているなら保存するだけで可能です。

vscodeでのformatはこちらのサイトを参照してください
https://flutter-master.com/flutter-start/code-format-vscode/

## コード

ファイル分割はこちらのサイトを参考にUI部分を`lib/view/`に、そのほかを`lib/model`において下さい。
https://note.com/nbht/n/n339076d40641

命名規則やコーディング規約はこちらのサイトに従います。
https://sbfl.net/blog/2014/12/20/dart-style-guide/
