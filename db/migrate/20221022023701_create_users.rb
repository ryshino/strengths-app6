class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false 
      t.string :profile, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false

      t.timestamps
      t.index :profile, unique: true
    end
  end
end
