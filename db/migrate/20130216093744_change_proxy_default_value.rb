class ChangeProxyDefaultValue < ActiveRecord::Migration
  def up
    change_column :http_proxies, :available, :boolean, default: false
  end

  def down
    change_column :http_proxies, :available, :boolean, default: true
  end
end
