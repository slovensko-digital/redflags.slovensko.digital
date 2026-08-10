class AllowNullOnUuidInMetaisProjectDocuments < ActiveRecord::Migration[5.1]
  def change
    change_column :'metais.project_documents', :uuid, :string, null: true
  end
end
