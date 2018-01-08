class AddIndexToParticipantManagements < ActiveRecord::Migration
  def change
    add_index :participant_managements, [:event_id, :user_id], unique: true
  end
end
