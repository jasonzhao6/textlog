class RenameAccomplishmentToObjective < ActiveRecord::Migration
  def change
    rename_column :activities, :accomplishment, :objective
  end
end
