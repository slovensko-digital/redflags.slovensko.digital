class AddDescriptionToMetaisProjectDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :'metais.project_documents', :description, :string
  end
end
