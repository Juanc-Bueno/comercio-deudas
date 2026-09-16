class CreatePagos < ActiveRecord::Migration[8.1]
  def change
    create_table :pagos do |t|
      t.references :factura, null: false, foreign_key: true
      t.references :medio_de_pago, null: false, foreign_key: true
      t.decimal :monto, precision: 12, scale: 2, null: false
      t.date :fecha, null: false

      t.timestamps
    end
  end
end
