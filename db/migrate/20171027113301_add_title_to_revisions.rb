class AddTitleToRevisions < ActiveRecord::Migration[5.1]
  def change
    add_column :revisions, :title, :string, null: false
  end
end
