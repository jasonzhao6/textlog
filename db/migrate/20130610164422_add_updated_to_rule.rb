class AddUpdatedToRule < ActiveRecord::Migration
  def change
    add_column :rules, :cnt_was_last_updated, :boolean
  end
end
