class AddPublishedAndLatestRevisionsToPages < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :pages, :published_revision, foreign_key: { to_table: :revisions }, null: true
    add_belongs_to :pages, :latest_revision, foreign_key: { to_table: :revisions }, null: true

    Page.find_each do |page|
      page.update(latest_revision_id: page.revisions.order(id: :asc).last.id)
    end
  end
end
