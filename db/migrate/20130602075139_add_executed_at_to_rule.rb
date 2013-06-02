class AddExecutedAtToRule < ActiveRecord::Migration
  def change
    add_column :rules, :executed_at, :datetime
  end
end
