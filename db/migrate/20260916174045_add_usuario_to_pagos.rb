class AddUsuarioToPagos < ActiveRecord::Migration[8.1]
  def change
    add_reference :pagos, :usuario, null: false, foreign_key: true
  end
end
