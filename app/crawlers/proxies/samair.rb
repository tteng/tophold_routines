#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Samair

  def process source_url
    #http://www.samair.ru/proxy/ip-address-%02d.htm
    (1..15).to_a.each do |i|
      STDOUT.puts source_url % i
      page = NetUtility.mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_pre = page_obj.search "pre"
    proxy_pre.search("a").remove
    proxy_pre.text.strip.split("\n").each do |row|
      parse_each_row row.gsub(/"'/,'')
    end
  end

  def parse_each_row row
    children = row.split
    ip_str, country = children[0], (children[4..-1].join(' ') rescue '')
    ip,port = ip_str.split ':' 
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
