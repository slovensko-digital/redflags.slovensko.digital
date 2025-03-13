class AddBenefitsToMetaisProjectOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.project_origins', :benefits, :decimal, precision: 15, scale: 2
  end
end
