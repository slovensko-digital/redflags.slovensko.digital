class AddMetaisCodeToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column 'projects', :metais_code, :string
  end
end
