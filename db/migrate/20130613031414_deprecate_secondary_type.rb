class DeprecateSecondaryType < ActiveRecord::Migration
  def change
    remove_column :activities, :secondary_type
    rename_column :activities, :primary_type, :activity
  end
end
