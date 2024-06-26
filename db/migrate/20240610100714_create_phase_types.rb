class CreatePhaseTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :phase_types do |t|
      t.string :name

      t.timestamps
    end

    PhaseType.reset_column_information
    PhaseType.create([
                       { name: 'Prípravná fáza' },
                       { name: 'Fáza produkt' }
                     ])
  end
end
