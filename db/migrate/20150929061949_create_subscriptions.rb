class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :question_id
      t.timestamps null: false
    end
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
