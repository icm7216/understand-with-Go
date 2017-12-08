# encoding:utf-8

# ------------------------------------------------------------------
# Make a EPUB for the "Goならわかるシステムプログラミング" with Pandoc.
#
# このスクリプトは、渋川よしき さんによるアスキーjpの「プログラミング＋」
# コーナーの連載「Goならわかるシステムプログラミング」からEPUBを作成します。
# 連載url => http://ascii.jp/elem/000/001/235/1235262/
#
# -------------------------------------------------------------------
# My environment:
# Windows 10 64bit, Ruby 2.3.3, pandoc 2.0.4
# mechanize (2.7.5)
# -------------------------------------------------------------------

require 'mechanize'

# epub-stylesheet
EPUB_CSS = 'understand_with_Go.css'

# output file name
HTML_OUT = 'understand_with_Go.html'
EPUB_OUT = 'understand_with_Go.epub'

# target url
target_host = 'http://ascii.jp/elem/000/'
target_domain = 'http://ascii.jp'

target_path = {
  part01: '001/234/1234843/',
  part02: '001/243/1243667/',
  part03: '001/252/1252961/',
  part041: '001/260/1260449/',
  part042: '001/260/1260449/index-2.html',
  part051: '001/267/1267477/',
  part052: '001/267/1267477/index-2.html',
  part06: '001/276/1276572/',
  part07: '001/403/1403717/',
  part08: '001/411/1411547/',
  part091: '001/415/1415088/',
  part092: '001/415/1415088/index-2.html',
  part10: '001/423/1423022/',
  part11: '001/430/1430904/',
  part12: '001/440/1440099/',
  part13: '001/451/1451470/',
  part14: '001/459/1459279/',
  part15: '001/467/1467705/',
  part16: '001/475/1475360/',
  part17: '001/480/1480872/',
  part18: '001/486/1486902/',
  part19: '001/496/1496211/',
  part20: '001/502/1502967/'
 }

# HTML header and TOC
all_html = <<HTML
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="author" content="渋川よしき">
<meta name="language" content="ja">
<meta name="description" content="この書籍は 渋川よしき さんによる、アスキーjpの「プログラミング＋」コーナーの連載「Goならわかるシステムプログラミング」から作成しています。">
<link rel="stylesheet" type="text/css" href="./#{EPUB_CSS}">
<title>Goならわかるシステムプログラミング</title>
</head>
<body>
<h1>Goならわかるシステムプログラミング</h1>
<p>この書籍は 渋川よしき さんによる、<a href="http://ascii.jp/">ASCII.jp</a> の「プログラミング＋」コーナーの連載「<a href="http://ascii.jp/elem/000/001/235/1235262/">Goならわかるシステムプログラミング</a>」から作成しています。</p>
<h2 id="toc">目次</h2>
<ul>
  <li><a href="#part01">第1回 Goで覗くシステムプログラミングの世界</a></li>
  <li><a href="#part02">第2回 低レベルアクセスへの入り口（1）：io.Writer</a></li>
  <li><a href="#part03">第3回 低レベルアクセスへの入り口（2）：io.Reader前編</a></li>
  <li><a href="#part041">第4回 低レベルアクセスへの入り口（3）：io.Reader後編 (1/2)</a></li>
  <li><a href="#part042">第4回 低レベルアクセスへの入り口（3）：io.Reader後編 (2/2)</a></li>
  <li><a href="#part051">第5回 Goから見たシステムコール (1/2)</a></li>
  <li><a href="#part052">第5回 Goから見たシステムコール (2/2)</a></li>
  <li><a href="#part06">第6回 GoでたたくTCPソケット（前編）</a></li>
  <li><a href="#part07">第7回 GoでたたくTCPソケット（後編）</a></li>
  <li><a href="#part08">第8回 UDPソケットをGoで叩く</a></li>
  <li><a href="#part091">第9回 Unixドメインソケット (1/2)</a></li>
  <li><a href="#part092">第9回 Unixドメインソケット (2/2)</a></li>
  <li><a href="#part10">第10回 ファイルシステムと、その上のGo言語の関数たち(1)</a></li>
  <li><a href="#part11">第11回 ファイルシステムと、その上のGo言語の関数たち(2)</a></li>
  <li><a href="#part12">第12回 ファイルシステムと、その上のGo言語の関数たち(3)</a></li>
  <li><a href="#part13">第13回 Go言語で知るプロセス（1）</a></li>
  <li><a href="#part14">第14回 Go言語で知るプロセス（2）</a></li>
  <li><a href="#part15">第15回 Go言語で知るプロセス（3）</a></li>
  <li><a href="#part16">第16回 Go言語と並列処理</a></li>
  <li><a href="#part17">第17回 Go言語と並列処理（2）</a></li>
  <li><a href="#part18">第18回 Go言語と並列処理（3）</a></li>
  <li><a href="#part19">第19回 Go言語のメモリ管理</a></li>
  <li><a href="#part20">第20回 Go言語とコンテナ</a></li>
</ul>
<hr>
<h1>Goならわかるシステムプログラミング（紙書籍）</h1>
<p>Web連載のコンテンツを、さらに加筆改定された書籍<a href="https://www.lambdanote.com/products/go">「Goならわかるシステムプログラミング（紙書籍）」</a>が<a href="https://www.lambdanote.com/">技術書出版ラムダノート株式会社</a>より出版されています。</p>
<hr>
HTML


# get contents
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'
title_list = []

target_path.each do |toc_id, path|
  html = ""
  page = agent.get("#{target_host}#{path}")
  
  post_title = page.at('#articleHead h1').text
  title_list << post_title
  
  # remove lines
  page.css('div.pickwrap').remove
  page.css('div#sideR').remove
  page.css('div.sbmV3').remove 
  page.css('ul.artsCont').remove 
  page.css('div#clubreco').remove 
  page.css('script').remove 
  page.css('h5.feature').remove 
  page.css('h5.related').remove 
  page.css('div.pages pgbottom').remove
  page.css('div#artAds').remove
  page.css('p.twitBtn').remove
  page.css('div.pages').remove
  page.css('p.returnCat').remove
  page.css('colgroup').remove
  
  # fix attribute
  h1_id = page.at('div#articleHead h1')
  h1_id["id"] = "#{toc_id}"
  p_href = page.at('div#articleHead p.sertitle a')
  p_href["href"] = "#toc"

  # Avoid the influence of "column" of Pandoc
  div_col = page.css('div.column')
  div_col.each {|x| x['class'] = x['class'].sub(/column/, 'col')}

  # remove ID duplication
  page.css('h2#クイズ').remove_attr('id')
  page.css('h2#今回のまとめと次回予告').remove_attr('id')
  page.css('h2#まとめと次回予告').remove_attr('id')
  page.css('h2#まとめ').remove_attr('id')
  page.css('h2#脚注').remove_attr('id')

  # download images
  page.css('img').each do |img|
    begin
      img_src = img.attribute("src").value
      match_list = img_src.match(/\/elem\/000\/.*?([^\/]+(?:(jpg)|(gif)))/)
      if match_list
        img_path = "./img/#{toc_id}/#{match_list[1]}"
        img_url = "#{target_domain}#{img_src}"
        agent.get(img_url).save img_path
        img["src"] = img_path
      end
    rescue Mechanize::ResponseCodeError => e
      puts 'Response Error #{e.response_code}: ' + img_src
    end
  end

  # make HTML contents
  body = page.at('div#mainC').to_html
  html << body
  all_html << html << "</div><hr>\n"

  # progress
  print "o"

  # load reduction for image download
  sleep(5) 
end

all_html << '</body></html>'

# display each title
puts "\nget title =>"
puts title_list.map {|x| x.gsub(/\n+/,'')}

# convert HTML to EPUB
puts "convert HTML to EPUB"

# output HTML
File.open(HTML_OUT, "w"){|w| w.puts all_html }
puts "output HTML => #{HTML_OUT}"

# output EPUB
system("pandoc -f html -t epub #{HTML_OUT} -o #{EPUB_OUT} --css=#{EPUB_CSS}")
puts "output EPUB => #{EPUB_OUT}"





