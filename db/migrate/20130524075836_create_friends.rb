class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t| # persist only those who were tagged in activities
      t.string :name # ("Scott Levy")
      t.string :fb_id # ("###")
    end
  end
end
