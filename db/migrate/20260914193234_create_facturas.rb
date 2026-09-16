class CreateFacturas < ActiveRecord::Migration[8.1]
  def change
    create_table :facturas do |t|
      t.references :proveedor, null: false, foreign_key: true
      t.string :numero, null: false
      t.date :fecha_emision, null: false
      t.date :fecha_vencimiento, null: false
      t.decimal :total, precision: 12, scale: 2, null: false

      t.timestamps
    end

    add_index :facturas, [ :proveedor_id, :numero ], unique: true
  end
end
