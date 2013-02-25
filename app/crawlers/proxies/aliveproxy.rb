#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Aliveproxy 

  def process source_url
    #http://www.aliveproxy.com/proxy-list-port-%d/
    [80, 81, 3128, 8000, 8080].each do |i|
      STDOUT.puts source_url % i
      page = NetUtility.mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//table[@class='cm or']//tr"
    p proxy_rows.size
    proxy_rows.to_a[1..-1].each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.children
    ip_string = children[0].inner_html
    ip, port = ip_string.split('<')[0].split ':'
    country = children[1].text.chomp
    STDOUT.puts ip_string
    STDOUT.puts port
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
