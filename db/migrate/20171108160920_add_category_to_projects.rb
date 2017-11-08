class AddCategoryToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :category, :integer, null: false, default: 2
  end
end
