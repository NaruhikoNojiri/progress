class CreateParticipantManagements < ActiveRecord::Migration
  def change
    create_table :participant_managements do |t|
      t.references :event, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :cancel_flag, null: false, default: false

      t.timestamps null: false
    end
  end
end
