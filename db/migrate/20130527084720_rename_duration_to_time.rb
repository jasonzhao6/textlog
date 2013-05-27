class RenameDurationToTime < ActiveRecord::Migration
  def change
    rename_column :activities, :duration, :time
  end
end
