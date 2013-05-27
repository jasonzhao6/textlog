class AddRepsToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :reps, :integer
  end
end
