class CreateSectors < ActiveRecord::Migration
  def self.up
    create_table :sectors do |t|
      t.string :name
      t.string :mc_code

      t.timestamps
    end
    
      
    add_index :sectors, :mc_code
  end

  def self.down
    drop_table :sectors
  end
end
