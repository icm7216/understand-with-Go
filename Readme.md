# understand-with-Go

Make a EPUB for the "Goならわかるシステムプログラミング" with Pandoc.

# Description

このスクリプトは、渋川よしき さんによる [ASCII.jp](http://ascii.jp/) の「プログラミング＋」コーナーの連載「[Goならわかるシステムプログラミング](http://ascii.jp/elem/000/001/235/1235262/)」からEPUBを作成します。

Web連載のコンテンツを、さらに加筆改定された書籍「[Goならわかるシステムプログラミング（紙書籍）](https://www.lambdanote.com/products/go)」が[技術書出版ラムダノート株式会社](https://www.lambdanote.com/)より出版されています。


# Usage

EPUB ファイルを作成するために [Pandoc](https://pandoc.org/) を使用しています。あらかじめインストールしておいてください。

```
ruby understand_with_Go.rb
```

*   スクリプトを実行すると EPUB ファイル`understand_with_Go.epub`が作成されます。
*   ファイルを閲覧するには EPUB リーダーを使用します。
    *   [EPUBReader – Firefox用の EPUB リーダーアドオン](https://addons.mozilla.org/ja/firefox/addon/epubreader/)

# My environment

Windows 10 64bit, Ruby 2.3.3, pandoc 2.0.4, mechanize (2.7.5)


# License

MIT

# Caution

「Goならわかるシステムプログラミング」のコンテンツの著作権は、株式会社KADOKAWAまたはコンテンツの著作権者が保有しています。作成した EPUB ファイルの取り扱いは十分に注意してください。

参考： [ASCII.jp サイトポリシー](http://ascii.jp/info/site_policy.html)