class CreateBalanceSheets < ActiveRecord::Migration
  def self.up
    create_table :balance_sheets do |t|
      t.date :period_ended

      t.float :total_share_capital, :equity_share_capital, :share_application_money, :preference_share_capital
      t.float :reserves, :revaluation_reserves, :net_worth, :secured_loans, :unsecured_loans
      t.float :total_debt, :total_liabilities
      t.float :gross_block, :accumulated_depreciation, :net_block, :capital_work_in_progress
      t.float :investments, :inventories, :sundry_debtors, :cash_and_bank_balance
      t.float :total_current_assets, :loans_and_advances, :fixed_deposits, :deferred_credit
      t.float :current_liabilities, :provisions, :net_current_assets, :misc_expenses
      t.float :total_assets, :contingent_liabilities, :book_value

      #Required by banks
      t.float :deposits, :borrowings, :other_liabilities
      t.float :balance_with_rbi, :money_at_call, :advances
      t.float :other_assets, :bills_for_collection

      t.string :type
      t.references :company
      t.timestamps
    end
    add_index :balance_sheets, [:company_id, :period_ended], :unique => true
  end

  def self.down
    drop_table :balance_sheets
  end
end
