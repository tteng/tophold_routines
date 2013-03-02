#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class VpnGeeks

  def process source_url
    #http://www.vpngeeks.com/proxylist.php?from=%d
    (0..55).to_a.each do |i|
      url = (source_url % (i * 50).succ)+"&country=0&port=&speed%5B%5D=1&speed%5B%5D=2&speed%5B%5D=3&anon%5B%5D=1&anon%5B%5D=2&anon%5B%5D=3&type%5B%5D=1&type%5B%5D=2&type%5B%5D=3&conn%5B%5D=1&conn%5B%5D=2&conn%5B%5D=3&sort=1&order=1&rows=50&search=Find"
      STDOUT.puts url
      page = NetUtility.mechanize_open_page url, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//tr[@class='tr_style1' or @class='tr_style2']"
    proxy_rows.to_a.each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.children
    ip, port, country, proxy_type = children[0].text, children[1].text, children[2].text, children[8].text
    return unless proxy_type =~ /http/i
    speed = children[6].inner_html =~ /width\:(.*)%/ ? $1.gsub(/['"]/,'').to_i : 50
    STDOUT.puts({ip: ip, port: port, speed: speed, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: speed, provider: country})
  end

end
