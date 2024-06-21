class AddPhaseToPages < ActiveRecord::Migration[5.1]
  def change
    add_reference :pages, :phase, index:true ,foreign_key: true
  end
end
