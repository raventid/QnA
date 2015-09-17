class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :token
      t.index [:email, :provider], unique: true

      t.timestamps null: false
    end
  end
end
