# http://developer.runkeeper.com/healthgraph/fitness-activities

class UpdateActivity < ActiveRecord::Migration
  def change
    rename_column :activities, :category, :primary_type
    rename_column :activities, :objective, :secondary_type
    rename_column :activities, :experience, :note
    rename_column :activities, :time, :duration
    add_column :activities, :distance, :float
    remove_column :activities, :name
  end
end
