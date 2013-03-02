#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class HideMyAss

  BIG_COLLECTION_URLS = ["search-225695"]

  def process url
    range = nil
    BIG_COLLECTION_URLS.each do |ul|
      if url.include? ul
        range = 1..42
        break 
      end
    end
    range ||= 1..8 
    range.to_a.each do |i|
      dest_url = url % i
      STDOUT.puts dest_url
      page = NetUtility.mechanize_open_page dest_url, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    proxy_rows = page_obj.search "//table[@id='listtable']//tr"
    proxy_rows.to_a[1..-1].each do |row|
      parse_each_row row
    end
  end

  def parse_each_row row
    style = row.search("style").remove
    visible, invisible = [], [] 
    style.children.text.split.each do |css|
      if css =~ /\.(.*)\{display\:(.*)\}$/
        case $2.strip.downcase
          when "inline"
            visible << $1
          when "none"
            invisible << $1
        end
      else
        STDOUT.puts "== Not matched css : #{css} ==" 
      end
    end
    tds = row.search('td').to_a
    return if tds.blank? || tds[1].blank? || tds[2].blank?
    ip_node, port = tds[1], tds[2].text.strip 
    ip_node.search("span[@style='display:none']").remove
    ip_node.search("div[@style='display:none']").remove
    invisible.each do |ivcs|
      ip_node.search("*[@class='#{ivcs}']").remove 
    end
    ip = ip_node.text.strip
    country = tds[3].text.strip
    speed_str = tds[4].search("div//div")[0].attributes["style"].to_s
    speed = $1.gsub(/['"]/,'').to_i if speed_str =~ /width\:(.*)%/
    STDOUT.puts({ip: ip, port: port, speed: speed, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: speed, provider: country})
  end

end
