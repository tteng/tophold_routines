#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Workingproxies

  def process source_url
    #http://www.workingproxies.org/?page=%d
    (0..39).each do |i|
      STDOUT.puts source_url % i
      page = NetUtility.mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//table[@class='proxies']//tr"
    proxy_rows.to_a[1..-2].each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    children = row.search("td").to_a
    ip = children[0].text.strip
    port = children[1].text.strip
    country = children[2].text.split(',')[1]
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
