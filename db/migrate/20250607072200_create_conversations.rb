class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :room, null: false, foreign_key: true

      t.string :title, null: false, default: ""

      t.timestamps
    end
  end
end
