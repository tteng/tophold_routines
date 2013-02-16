class CreateHttpProxies < ActiveRecord::Migration
  def change
    create_table :http_proxies do |t|
      t.string  :ip
      t.integer :port
      t.integer :speed, :default => 50
      t.boolean :available, default: true
      t.integer :country
      t.datetime :last_used_at
      t.datetime :verified_at
      t.timestamps
    end
    add_index :http_proxies, [:ip, :port], :name => "ip_port_uniq_idx", :uniq => true
    add_index :http_proxies, [:verified_at, :speed], :name => "verify_speed_idx", :order => {:verified_at => :desc, :speed => :desc}
  end
end
