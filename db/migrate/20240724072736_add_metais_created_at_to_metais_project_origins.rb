class AddMetaisCreatedAtToMetaisProjectOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column 'metais.project_origins', :metais_created_at, :datetime
  end
end
