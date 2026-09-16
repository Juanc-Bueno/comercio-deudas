class CreateMediosDePago < ActiveRecord::Migration[8.1]
  def change
    create_table :medios_de_pago do |t|
      t.string :nombre, null: false
      t.boolean :activo, null: false, default: true

      t.timestamps
    end

    add_index :medios_de_pago, :nombre, unique: true
  end
end
