class CreateClientPatients < ActiveRecord::Migration[7.0]
  def change
    create_table :client_patients do |t|
      t.references :team, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
