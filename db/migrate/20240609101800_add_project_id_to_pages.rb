class AddProjectIdToPages < ActiveRecord::Migration[5.1]
  def change
    add_reference :pages, :project, index:true, foreign_key: true
  end
end
