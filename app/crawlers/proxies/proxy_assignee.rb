require 'hide_my_ass'

class ProxyAssignee

  def self.start 
    ProxySource.all.each do |ps| 
      case ps.url
        when /hidemyass\.com/i
          HideMyAss.new.process ps.url          
      end
    end
  end

end
