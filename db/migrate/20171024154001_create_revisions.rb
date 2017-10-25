class CreateRevisions < ActiveRecord::Migration[5.1]
  def change
    create_table :revisions do |t|
      t.belongs_to :page, foreign_key: true, null: false
      t.integer :version, null: false
      t.jsonb :raw

      t.timestamps
    end

    add_index :revisions, [:page_id, :version], unique: true
  end
end
