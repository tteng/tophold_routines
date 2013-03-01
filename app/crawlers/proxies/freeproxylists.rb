#encoding: utf-8
require 'url_escaper'
require 'net_utility'
require 'open-uri'
require 'mechanize'

class Freeproxylists

  def mechanize_open_page url, with_proxy=false, encoding='utf-8', max_try_count=5, sleep_interval=10
    p "url: #{url}"
    try_count = 0
    begin
      a = Mechanize.new 
      p "with_proxy: #{with_proxy}"
      a.set_proxy(configatron.cross_gfw_proxy_url, configatron.cross_gfw_proxy_port) if with_proxy
      body = a.get(url).body
      p body
      page = Nokogiri::HTML(body)
    rescue Exception => e
      STDOUT.puts "open #{url} failed caused by #{e.message}"
      raise e
      try_count += 1 
      if try_count < max_try_count 
        sleep sleep_interval 
        retry
      else
        page = nil
      end
    end 
    block_given? ? yield(page) : page
  end


  def process source_url
    #http://www.freeproxylists.net/?page=%d 
    (1..50).to_a.each do |i|
      STDOUT.puts source_url % i
      page = mechanize_open_page source_url % i, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    p page_obj.inner_html
    raise "break ..."
    proxy_rows = page_obj.search "//tr[@class='Odd' or @class='Even']"
    proxy_rows.to_a.each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    p row.inner_html
    children = row.children
    ip_string = children[0].inner_html
    ip, port = ip_string.split('<')[0].split ':'
    country = children[1].text.strip
    STDOUT.puts({ip: ip, port: port, speed: 50, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: 50, provider: country})
  end

end
