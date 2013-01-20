githubackup
===========

A program to periodically back up one's repositories hosted on GitHub

ずんだコード http://atnd.org/events/35787
で作成するプログラムの建設予定地です。

zundaがずんだコードで習いたいこと
---------------------------------
* 最初の一行をどこからどうやって書くか
* 欲しい機能のどこから書いていくか
  * 既存のライブラリの探し方
* Web service (API)を利用したプログラムの書き方
  * テストをどう書くか
* gitとのおつきあい
  * addやcommitの粒度・タイミング
* ライセンスの記述やドキュメントなどの整備をどういうタイミングで進めるか
  * 割と最初に決まりました。Web serviceじゃないのでAGPLじゃなくていいよね
  * ライセンスの元はUbuntuの場合は /usr/share/common-licenses
    * GPL-2からライセンス文をコピー

コードの書き方にはあんまり興味はないけどとりあえずGitHubにある情報を
バックアップしておきたい、
という人は下記のURLを参考にすると幸せになるかもしれません。
ずんだコードでは車輪の再発明は厭わないことにしまっす。

* [Pro-tip: How To Backup All Of Your GitHub Repositories In One Go](http://addyosmani.com/blog/backing-up-a-github-account/)

このプログラムの使い方
----------------------
このプログラムは、あるGitHubのユーザーがGitHubにホストしてもらっている
レポジトリの一覧を作成して、それぞれのレポジトリのcloneあるいはpullを
cronなどによって実行するものです。

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

You should have received a copy of [the GNU General Public License](http://www.gnu.org/licenses/gpl-2.0.html) along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

