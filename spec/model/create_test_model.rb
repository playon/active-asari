class CreateTestModel < ActiveRecord::Migration
  def self.up
    create_table :test_models do |t|
      t.string :name
      t.integer :amount
    end
  end

  def self.down
    drop_table :test_models
  end
end
