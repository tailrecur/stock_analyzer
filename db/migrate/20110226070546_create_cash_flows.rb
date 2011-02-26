class CreateCashFlows < ActiveRecord::Migration
  def self.up
    create_table :cash_flows do |t|
      t.date :period_ended

      t.float :cash_from_operations, :cash_from_investment, :cash_from_financing
      t.float :change_in_cce, :opening_cce, :closing_cce

      t.references :company
      t.timestamps
    end
    add_index :cash_flows, [:company_id, :period_ended], :unique => true
    add_column :companies, :cash_flows_count, :integer, :default => 0
  end

  def self.down
    drop_table :cash_flows
    remove_column :companies, :cash_flows_count
  end
end
