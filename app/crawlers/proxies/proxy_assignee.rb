require 'hide_my_ass'

class ProxyAssignee

  def self.start 
    handler = ProxySource.all.each do |ps| 
      case ps.url
        when /hidemyass\.com/i
          HideMyAss
        when /vpngeeks\.com/i
          VpnGeeks
        when /aliveproxy\.com/i
          Aliveproxy
        when /proxynova\.com/i
          Proxynova
        else
          nil
      end
    end
    handler.new.process ps.url unless handler.blank?
  end

end
