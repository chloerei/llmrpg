class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :room, null: false, foreign_key: true, type: :uuid

      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""

      t.timestamps
    end
  end
end
