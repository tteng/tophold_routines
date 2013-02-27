#encoding: utf-8
require 'url_escaper'
require 'net_utility'

class Proxynova

  DEFAULT_ENCODE_JS = %Q{
                   var _0xb200=["\x32","\x72\x65\x70\x6C\x61\x63\x65","\x33","\x38","\x2E","\x6A\x6F\x69\x6E"];
                   function decode(_0x997cx2){
                     var _0x997cx2=_0x997cx2[_0xb200[1]](/fgh/g,_0xb200[0]);
                     _0x997cx2=_0x997cx2[_0xb200[1]](/vbn/g,_0xb200[2]);
                     _0x997cx2=_0x997cx2[_0xb200[1]](/rty/g,_0xb200[3]);
                     var _0x997cx3=_0x997cx2;
                     if(!isFinite(_0x997cx3)){
                       return false;
                     };
                    return [_0x997cx3>>>24,_0x997cx3>>>16&0xFF,_0x997cx3>>>8&0xFF,_0x997cx3&0xFF][_0xb200[5]](_0xb200[4]);
                   } 
               }

  def process source_url
    #http://www.proxynova.com/proxy-server-list/port-%d/
    [80, 8080, 3128].each do |i|
      url = source_url % i
      STDOUT.puts url
      page = NetUtility.mechanize_open_page url, (ENV['NO_GFW_PROXY'] ? false : true)
      grab_proxies page
    end
  end

  def grab_proxies page_obj
    decode_cxt = parse_ip_encoder page_obj
    proxy_rows = page_obj.search "//table[@id='tbl_proxy_list']//tr"
    proxy_rows.to_a[1..-2].each do |row|
      parse_each_row row, decode_cxt
    end
  end

  def parse_each_row row, decode_cxt
    children = row.search "td"
    ip_string = children[0].text
    unless ip_string.blank?
      ip = ip_string =~ /decode\(['"](.*)['"]\)/ ?  decode_cxt.eval("decode('#{$1}')") : nil
    else
      return
    end
    port, country =  children[1].text.strip, (children[5].text.split('-')[0].strip rescue nil)
    speed = children[3].inner_html =~ /data-percent=(.*)/ ? $1.gsub(/['"]/,'').to_i : 50
    STDOUT.puts({ip: ip, port: port, speed: speed, provider: country})
    HttpProxy.create({ip: ip, port: port, speed: speed, provider: country})
  end

  def parse_ip_encoder page_obj
    encode_js_node = page_obj.css('script').detect{|sc| sc.children.text =~ /var\s+_0xb200(\s+)?\=(\s+)?\[/}
    unless encode_js_node.blank?
      str = encode_js_node.text
      js =  str =~ /(var\s+_0xb200(\s+)?\=(\s+)?\[.*)\$\(document\)\.ready/m ? $1 : DEFAULT_ENCODE_JS
    else
     js = DEFAULT_ENCODE_JS
    end
    cxt = V8::Context.new
    cxt.eval js
    cxt
  end

end
