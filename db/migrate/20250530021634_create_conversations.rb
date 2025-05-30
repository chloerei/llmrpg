class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :persona, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
