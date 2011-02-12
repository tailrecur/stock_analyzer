class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :mc_code
      t.references :sector
      t.timestamps
    end
    
    add_index :companies, :mc_code, :unique => true
    add_index :companies, :sector_id
  end

  def self.down
    drop_table :companies
  end
end
