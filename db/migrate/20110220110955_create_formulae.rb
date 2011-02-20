class CreateFormulae < ActiveRecord::Migration
  def self.up
    create_table :formulae do |t|
      t.string :value
      t.integer :weight, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :formulae
  end
end
