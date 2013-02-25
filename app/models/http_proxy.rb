#encoding: utf-8
class HttpProxy < ActiveRecord::Base

  attr_accessible :ip, :port, :speed, :available, :validated_at, :last_used_at, :country, :provider

  SourceCountry = Hash.new(2)
  SourceCountry["china"] = 0
  SourceCountry["cn"] = 0
  SourceCountry["united states"] = 1
  SourceCountry["america"] = 1
  SourceCountry["us"] = 1

  def provider= (country="")
    self.country = SourceCountry[country.chomp.downcase]
  end

  IP_REGEXP = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/

  validates :port, presence: true 
  validates :ip,   presence: true, uniqueness: {:scope => :port}, format: {with: IP_REGEXP}

end
