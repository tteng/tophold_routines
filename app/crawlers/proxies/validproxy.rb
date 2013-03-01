#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Validproxy

  def process source_url
    #http://valid-proxy.com/en/proxylist/country/asc/%d/
    (1..85).to_a.each do |i|
      STDOUT.puts source_url % i
      page = NetUtility.mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    tables = page_obj.search "//table[@class='proxylist']"
    proxy_rows = tables[1].search "tr"
    proxy_rows.to_a.each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.search "td"
    country = children[6].text.strip
    return if country =~ /private/i
    ip = children[0].text.strip
    port = children[1].text.strip
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
