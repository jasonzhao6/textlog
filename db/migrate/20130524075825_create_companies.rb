class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :activity_id
      t.integer :friend_id
    end
  end
end
