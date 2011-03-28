class CreateStockTransactions < ActiveRecord::Migration
  def self.up
    create_table :stock_transactions do |t|
      t.string :transaction_type
      t.integer :quantity
      t.float :transaction_price
      t.date :transaction_date
      t.string :exchange

      t.references :company

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_transactions
  end
end
