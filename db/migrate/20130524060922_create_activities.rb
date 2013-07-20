class CreateActivities < ActiveRecord::Migration
  def change
    # I manually curate unparsed messages at the end of the day
    add_column :messages, :parsed, :boolean

    create_table :activities do |t|
      t.integer :message_id # "Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Engaged."
      t.string :name # "Biking"
      t.string :category # "Workout"
      t.string :accomplishment # "Butterlap"
      t.string :company_id # (FB ID integration)
      t.integer :duration # "90"
      t.string :mood
      t.string :location # ("Lands End, SF")
      t.string :formatted_address # (http://maps.googleapis.com/maps/api/geocode/json?address=Lands%20End,%20SF&sensor=false)
      t.string :lat
      t.string :lng
      t.string :viewport
    end
  end
end
