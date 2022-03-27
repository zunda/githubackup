githubackup
===========

A program to periodically back up one's repositories hosted on GitHub

The unauthenticated git protocol on port 9418 is no longer supported.
---------------------------------------------------------------------

2022-03-27 [GitHubによるセキュリティ強化](https://github.blog/2021-09-01-improving-git-protocol-security-github/)の一環として、このプログラムで利用している`git`プロトコルによる非認証アクセスが不許可になりました。改良の時間ができるまでこのレポジトリはアーカイブします。

このプログラムの使い方
----------------------
このプログラムは、あるGitHubのユーザーがGitHubにホストしてもらっている
レポジトリの一覧を作成して、それぞれのレポジトリのミラーあるいは更新を
cronなどによって実行するものです。

例えば、
```
githubackup -u zunda -d /backup/repos
```
を実行すると、GitHubユーザー```zunda```の
公開レポジトリのミラーを、```/backup/repos```以下に作成あるいは更新します。

この他のオプションについては、
```
githubackup -h
```
を参照してください。

いまのところ、プログラムをインストールする方法が準備されていませんので、
```
ruby bin/githubackup
```
とファイルを指定して実行してください。

ライセンス
----------
A program to periodically back up one's repositories hosted on GitHub

Copyright (C) 2013 zunda <zunda at freeshell.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received [a copy of the GNU General Public License](GPL-2.txt) along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

ずんだコード
------------
このプロジェクトは、
[ずんだコード](http://atnd.org/events/35787)
で作成の始まったプロジェクトです。
ずんだコードの様子は、[Wikiページ](https://github.com/zunda/githubackup/wiki)
にまとめました。

コードの書き方にはあんまり興味はないけどとりあえずGitHubにある情報を
バックアップしておきたい、
という人は下記のURLを参考にすると幸せになるかもしれません。
ずんだコードでは車輪の再発明は厭わないことにしまっす。

* [Pro-tip: How To Backup All Of Your GitHub Repositories In One Go](http://addyosmani.com/blog/backing-up-a-github-account/)
