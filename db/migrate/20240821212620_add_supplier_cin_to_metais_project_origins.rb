class AddSupplierCinToMetaisProjectOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.project_origins', :supplier_cin, :bigint
  end
end
