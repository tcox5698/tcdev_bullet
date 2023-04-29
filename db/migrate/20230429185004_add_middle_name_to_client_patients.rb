class AddMiddleNameToClientPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :client_patients, :middle_name, :string
  end
end
