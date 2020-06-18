class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :match, null: true, foreign_key: true
      t.references :winner, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
