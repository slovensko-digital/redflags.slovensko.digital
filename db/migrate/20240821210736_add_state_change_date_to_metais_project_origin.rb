class AddStateChangeDateToMetaisProjectOrigin < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.project_origins', :status_change_date, :datetime
  end
end
