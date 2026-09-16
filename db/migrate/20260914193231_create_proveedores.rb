class CreateProveedores < ActiveRecord::Migration[8.1]
  def change
    create_table :proveedores do |t|
      t.string :nombre, null: false
      t.string :cuit, null: false
      t.string :email
      t.string :telefono
      t.string :direccion
      t.boolean :activo, null: false, default: true

      t.timestamps
    end

    add_index :proveedores, :cuit, unique: true
  end
end
