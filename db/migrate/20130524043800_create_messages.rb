class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.timestamps
      t.string :body
    end
  end
end
