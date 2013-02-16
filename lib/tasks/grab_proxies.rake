#encoding: utf-8
namespace :routines do

  desc "GRAB FREE PROXIES FROM HIDEMYASS.COM"
  task :grab_hide_my_ass_proxies => :environment do
    HideMyAss.new.start
  end

end
