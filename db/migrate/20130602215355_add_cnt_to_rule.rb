class AddCntToRule < ActiveRecord::Migration
  def change
    add_column :rules, :cnt, :integer, default: 0
  end
end
