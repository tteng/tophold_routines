require 'hide_my_ass'

class ProxyAssignee

  def self.start 
    ProxySource.all.each do |ps| 
      handler = case ps.url
          when /hidemyass\.com/i
            HideMyAss
          when /vpngeeks\.com/i
            VpnGeeks
          when /aliveproxy\.com/i
            Aliveproxy
          when /proxynova\.com/i
            Proxynova
          when /ip-address\.com/i
            IpAddress
          when /xroxy\.com/i
            Xroxy
          when /workingproxies\.com/i
            Workingproxies
          when /proxyserver\.com/i
            Proxyserver
          when /valid-proxy\.com/i
            Validproxy
          when /samair\.ru/i
            Samair 
          when /freeproxylists\.net/i
            #Freeproxylists
          else
            nil
      end
      handler.new.process ps.url unless handler.blank?
    end
  end

  #http://www.proxz.com/

end
