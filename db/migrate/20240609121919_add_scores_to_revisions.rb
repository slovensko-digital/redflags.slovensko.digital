class AddScoresToRevisions < ActiveRecord::Migration[5.1]
  def change
    add_column :revisions, :total_score, :integer
    add_column :revisions, :maximum_score, :integer
    add_column :revisions, :redflags_count, :integer, default: 0
  end
end
