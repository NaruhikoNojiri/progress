class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :self_introduction, :text, null: false
    add_column :users, :uid, :string, null: false, default: ""
    add_column :users, :provider, :string, null: false, default: ""
    add_column :users, :image_url, :string
    add_column :users, :avatar, :string
    add_column :users, :admin, :boolean, null: false, default: false

    add_index :users, [:uid, :provider], unique: true

  end
end
