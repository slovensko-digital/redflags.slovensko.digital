class RemovePageIdFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_reference :projects, :page, index: true, foreign_key: true
  end
end
