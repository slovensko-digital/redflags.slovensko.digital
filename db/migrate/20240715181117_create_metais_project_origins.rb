class CreateMetaisProjectOrigins < ActiveRecord::Migration[5.1]
  def change
    create_table 'metais.origin_types' do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table 'metais.project_origins' do |t|
      t.references :project, null: false, index: true, foreign_key: { to_table: 'metais.projects' }
      t.references :origin_type, null: false, index: true, foreign_key: { to_table: 'metais.origin_types' }

      t.string :title, null: false
      t.string :status
      t.text :description
      t.string :guarantor
      t.string :project_manager
      t.datetime :start_date
      t.datetime :end_date

      t.string :finance_source
      t.decimal :investment, :precision => 15, :scale => 2
      t.decimal :operation, :precision => 15, :scale => 2

      t.string :supplier

      t.text :targets_text
      t.text :events_text
      t.text :documents_text
      t.text :links_text

      t.timestamps
    end
  end
end
