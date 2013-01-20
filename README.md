githubackup
===========

A program to periodically back up one's repositories hosted on GitHub

ずんだコード http://atnd.org/events/35787
で作成するプログラムの建設予定地です。

zundaがずんだコードで習いたいこと
---------------------------------
* 最初の一行をどうやって書くか
* 欲しい機能のどこから書いていくか
* Web service (API)を利用したプログラムの書き方
  * テストをどう書くか

コードの書き方にはあんまり興味はないけどとりあえずGitHubにある情報を
バックアップしておきたい、
という人は下記のURLを参考にすると幸せになるかもしれません。
ずんだコードでは車輪の再発明は厭わないことにしまっす。

* [Pro-tip: How To Backup All Of Your GitHub Repositories In One Go][http://addyosmani.com/blog/backing-up-a-github-account/]

このプログラムの使い方
----------------------
このプログラムは、あるGitHubのユーザーがGitHubにホストしてもらっている
レポジトリの一覧を作成して、それぞれのレポジトリのcloneあるいはpullを
cronなどによって実行するものです。

ライセンス
----------

