class RemoveLocationFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :location
    remove_column :activities, :formatted_address
    remove_column :activities, :lat
    remove_column :activities, :lng
    remove_column :activities, :viewport
  end
end
