class CreateProfitAndLosses < ActiveRecord::Migration
  def self.up
    create_table :profit_and_losses do |t|
      t.date :period_ended

      t.float :sales_turnover, :excise_duty, :net_sales, :other_income, :stock_adjustments, :total_income
      t.float :raw_materials, :power_and_fuel_cost, :employee_cost, :other_manufacturing_expenses, :sales_and_admin_expenses
      t.float :misc_expenses, :preoperative_capex, :total_expenses
      t.float :operating_profit, :pbdit, :interest, :pbdt, :depreciation, :other_written_off, :pbt, :extraordinary_items
      t.float :tax, :net_profit, :total_value_addition, :preference_dividend, :equity_dividend, :dividend_tax
      t.float :issued_shares, :eps, :dividend_percentage, :book_value

      t.references :company
      t.timestamps
    end
    add_index :profit_and_losses, [:company_id, :period_ended], :unique => true
    add_column :companies, :profit_and_losses_count, :integer, :default => 0
  end

  def self.down
    drop_table :profit_and_losses
    remove_column :companies, :profit_and_losses_count
  end
end
