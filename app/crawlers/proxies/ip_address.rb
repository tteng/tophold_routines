#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class IpAddress

  def process source_url
    #http://www.ip-adress.com/proxy_list/?k=time&d=desc
    page = NetUtility.mechanize_open_page source_url, (ENV['NO_GFW_PROXY'] ? false : true)
    grab_proxies page
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//table[@class='proxylist']//tr"
    proxy_rows.to_a[2..-2].each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.search("td").to_a
    ip_string = children[0].text
    ip, port = ip_string.split ':'
    country = children[2].text.strip
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
