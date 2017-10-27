class TruncatePagesAndRevisions < ActiveRecord::Migration[5.1]
  def change
    Page.find_each do |page|
      page.update(latest_revision_id: nil)
    end

    Revision.delete_all
    Page.delete_all
  end
end
