#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class VpnGeeks

  def process source_url
    #http://www.vpngeeks.com/proxylist.php?from=%d&#pagination
    (0..55).to_a.each do |i|
      url = source_url % (i * 50).succ
      STDOUT.puts url
      page = NetUtility.mechanize_open_page url, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//tr[@class='tr_style1' or @class='tr_style2']"
    p proxy_rows.size
    proxy_rows.to_a.each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.children
    proxy_type = STDOUT.puts children[8].text
    return unless proxy_type =~ /http/i
    ip, port, country = children[0].text, children[1].text, children[2].text
    speed = children[6].inner_html =~ /width\:(.*)%/ ? $1.gsub(/['"]/,'').to_i : 50
    STDOUT.puts({ip: ip, port: port, speed: speed, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: speed, provider: country})
  end

end
