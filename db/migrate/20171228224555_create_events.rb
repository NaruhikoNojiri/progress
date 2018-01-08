class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false
      t.text :summary, null: false
      t.string :place, null: false
      t.string :place_address, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.integer :capacity, null: false
      t.integer :fee

      t.timestamps null: false
    end
  end
end
