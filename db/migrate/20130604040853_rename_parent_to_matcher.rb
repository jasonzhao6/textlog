class RenameParentToMatcher < ActiveRecord::Migration
  def change
    rename_column :rules, :parent_id, :matcher_id
  end
end
