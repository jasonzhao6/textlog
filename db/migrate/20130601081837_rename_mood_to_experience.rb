class RenameMoodToExperience < ActiveRecord::Migration
  def change
    rename_column :activities, :mood, :experience
  end
end
