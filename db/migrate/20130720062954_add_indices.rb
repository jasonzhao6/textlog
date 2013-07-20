class AddIndices < ActiveRecord::Migration
  def change
    remove_column :activities, :company_id
    add_index :activities, :message_id
    add_index :activities, :activity
    add_index :companies, :activity_id
    add_index :companies, :friend_id
    add_index :friends, :fb_id
    add_index :rules, :matcher_id
    add_index :rules, :command
  end
end
