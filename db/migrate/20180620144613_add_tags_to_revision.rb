class AddTagsToRevision < ActiveRecord::Migration[5.1]
  def change
    add_column :revisions, :tags, :string, array: true, default: []
    add_index :revisions, :tags, using: 'gin'
  end
end
