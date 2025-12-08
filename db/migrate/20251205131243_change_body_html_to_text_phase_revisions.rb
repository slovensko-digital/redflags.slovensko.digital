class ChangeBodyHtmlToTextPhaseRevisions < ActiveRecord::Migration[5.1]
  def change
    change_column :phase_revisions, :body_html, :text
  end
end
