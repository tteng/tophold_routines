#coding: utf-8
class UrlEscaper

  def self.join *args
    base_url = args.shift 
    unless args.blank?
      args.each do |arg|
        base_url = URI.join(base_url, filter(arg)).to_s
      end
    end
    base_url.to_s
  end

  private

  def self.filter s
    s.gsub(/\s/,'%20').gsub('[','%5B').gsub(']','%5D')  
  end

end
