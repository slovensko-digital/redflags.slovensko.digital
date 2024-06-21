class AddPageTypeToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :page_type, :integer, default: 0
  end
end
