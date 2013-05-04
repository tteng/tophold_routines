class AddSosoRankAndSosoScoreToTags < ActiveRecord::Migration
  def change
    add_column :tags, :soso_rank, :integer, :default => 0
    add_column :tags, :soso_score, :integer, :default => 0
  end
end
