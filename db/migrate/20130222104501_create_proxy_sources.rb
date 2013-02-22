class CreateProxySources < ActiveRecord::Migration
  def change
    create_table :proxy_sources do |t|
      t.string :url
      t.integer :source
      t.timestamps
    end
    add_index :proxy_sources, :url, :name => 'url_idx', :unique => true
  end
end
