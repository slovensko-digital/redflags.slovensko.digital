class AddSummaryAndRecommendationToProjectRevision < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :summary, :text
    add_column :project_revisions, :recommendation, :text
  end
end
