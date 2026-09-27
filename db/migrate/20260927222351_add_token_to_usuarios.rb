class AddTokenToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :token, :string
    add_index :usuarios, :token, unique: true
  end
end
