class CreateProjectStages < ActiveRecord::Migration[5.1]
  class ProjectStage < ActiveRecord::Base
  end

  def change
    create_table :project_stages do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
