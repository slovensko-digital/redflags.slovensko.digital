class AddHappeningNowToProjectRevision < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :happening_now, :string
  end
end
