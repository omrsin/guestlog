class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :contact
      t.string :image
      t.integer :user_id
      t.integer :guest_id

      t.timestamps
    end
    add_index :visits, [:user_id, :created_at]
    add_index :visits, [:guest_id]
  end
end
