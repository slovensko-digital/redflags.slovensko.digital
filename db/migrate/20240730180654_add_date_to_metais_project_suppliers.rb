class AddDateToMetaisProjectSuppliers < ActiveRecord::Migration[5.1]
  def change
    add_column 'metais.project_suppliers', :date, :datetime
  end
end
