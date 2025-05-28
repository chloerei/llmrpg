class CreatePersonas < ActiveRecord::Migration[8.0]
  def change
    create_table :personas do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
