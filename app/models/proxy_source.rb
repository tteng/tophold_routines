class ProxySource < ActiveRecord::Base

  attr_accessible :source, :url

  module SOURCE
    HIDE_MY_ASS = 0
  end

  validates :url, :presence => true, :uniqueness => {:case_sensitive => false} 

end
