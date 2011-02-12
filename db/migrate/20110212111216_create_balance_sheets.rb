class CreateBalanceSheets < ActiveRecord::Migration
  def self.up
    create_table :balance_sheets do |t|
      t.date :period_ended

      t.timestamps
    end
  end

  def self.down
    drop_table :balance_sheets
  end
end
