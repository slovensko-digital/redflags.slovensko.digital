class CreateMetaisProjectItems < ActiveRecord::Migration[5.1]
  def change
    create_table 'metais.project_events' do |t|
      t.references :project_origin, null: false, index: true, foreign_key: { to_table: 'metais.project_origins' }
      t.references :origin_type, null: false, index: true, foreign_key: { to_table: 'metais.origin_types' }

      t.string :name, null: false
      t.string :value, null: false
      t.datetime :date, null: false

      t.timestamps
    end

    create_table 'metais.supplier_types' do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table 'metais.project_suppliers' do |t|
      t.references :project_origin, null: false, index: true, foreign_key: { to_table: 'metais.project_origins' }
      t.references :origin_type, null: false, index: true, foreign_key: { to_table: 'metais.origin_types' }
      t.references :supplier_type, null: false, index: true, foreign_key: { to_table: 'metais.supplier_types' }

      t.string :name, null: false
      t.string :value, null: false

      t.timestamps
    end

    create_table 'metais.project_documents' do |t|
      t.references :project_origin, null: false, index: true, foreign_key: { to_table: 'metais.project_origins' }
      t.references :origin_type, null: false, index: true, foreign_key: { to_table: 'metais.origin_types' }

      t.string :name, null: false
      t.string :value, null: false

      t.timestamps
    end

    create_table 'metais.project_links' do |t|
      t.references :project_origin, null: false, index: true, foreign_key: { to_table: 'metais.project_origins' }
      t.references :origin_type, null: false, index: true, foreign_key: { to_table: 'metais.origin_types' }

      t.string :name, null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
