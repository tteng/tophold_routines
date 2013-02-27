#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Xroxy

  def process source_url
    #http://www.xroxy.com/proxylist.php?port=&type=All_http&ssl=&country=&latency=&reliability=&sort=reliability&desc=true&pnum=%d/
    (1..315).to_a.each do |i|
      STDOUT.puts source_url % i
      page = NetUtility.mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//tr[@class='row0' or @class='row1']"
    proxy_rows.to_a.each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.search("td").to_a
    ip, port = children[1].text.strip, children[2].text.strip
    country = children[5].text.strip.strip
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
