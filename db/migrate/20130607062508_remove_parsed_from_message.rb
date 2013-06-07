class RemoveParsedFromMessage < ActiveRecord::Migration
  def change
    remove_column :messages, :parsed
  end
end
