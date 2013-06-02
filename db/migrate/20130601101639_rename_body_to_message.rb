class RenameBodyToMessage < ActiveRecord::Migration
  def change
    rename_column :messages, :body, :message
  end
end
