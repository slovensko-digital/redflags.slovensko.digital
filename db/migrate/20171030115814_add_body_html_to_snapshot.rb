class AddBodyHtmlToSnapshot < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :body_html, :string
  end
end
