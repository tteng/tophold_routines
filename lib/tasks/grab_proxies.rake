#encoding: utf-8
namespace :routines do

  desc "GRAB FREE PROXIES FROM INTERNET"
  task :grab_proxies => :environment do
    ProxyAssignee.start
  end

end
