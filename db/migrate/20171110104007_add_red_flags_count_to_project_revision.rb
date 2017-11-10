class AddRedFlagsCountToProjectRevision < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :redflags_count, :integer, default: 0
  end
end
