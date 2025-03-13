class AddUuidToMetaisProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.projects', :uuid, :string
  end
end
