class RemoveExecutedAtToRule < ActiveRecord::Migration
  def change
    remove_column :rules, :executed_at
  end
end
