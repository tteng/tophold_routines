#encoding: utf-8
require 'nokogiri'
require 'open-uri'
require 'mechanize'

class NetUtility

  class << self

    def mechanize_open_page url, with_proxy=false, encoding='utf-8', max_try_count=5, sleep_interval=10
      try_count = 0
      begin
        a = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari'}
        a.set_proxy(configatron.cross_gfw_proxy_url, configatron.cross_gfw_proxy_port) if with_proxy
        page = Nokogiri::HTML(a.get(url).body)
      rescue Exception => e
        STDOUT.puts "open #{url} failed caused by #{e.message}"
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

    def open_page url, with_proxy=false, encoding='utf-8', max_try_count=5, sleep_interval=10
      try_count = 0
      begin 
        page = Nokogiri::HTML((with_proxy ? open(url, :proxy => "http://#{configatron.cross_gfw_proxy_url}:#{configatron.cross_gfw_proxy_port}") : open(url)), nil, encoding) 
      rescue Exception => e
        STDOUT.puts "open #{url} failed caused by #{e.message}"
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
    
  end

end
