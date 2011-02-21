class AddScoreToCompany < ActiveRecord::Migration
  def self.up
    change_table :companies do |t|
      t.integer :score, :default => 0
    end
  end

  def self.down
    change_table :companies do |t|
      t.remove :score
    end
  end
end
