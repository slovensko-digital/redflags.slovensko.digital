class AddPhaseApprovedFinancesToMetaisProjectOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column 'metais.project_origins', :phase, :string
    add_column 'metais.project_origins', :approved_investment, :decimal, precision: 15, scale: 2
    add_column 'metais.project_origins', :approved_operation, :decimal, precision: 15, scale: 2
  end
end
