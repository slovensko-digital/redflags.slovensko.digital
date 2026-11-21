class AddFilenameAndUuidToMetaisProjectDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.project_documents', :filename, :string
    add_column :'metais.project_documents', :uuid, :string, null: false
  end
end
