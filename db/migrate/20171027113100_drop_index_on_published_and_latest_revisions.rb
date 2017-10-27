class DropIndexOnPublishedAndLatestRevisions < ActiveRecord::Migration[5.1]
  def change
    remove_index :pages, :published_revision_id
    remove_index :pages, :latest_revision_id
  end
end
