class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :first_team, null: false, foreign_key: { to_table: :teams }
      t.references :second_team, null: false, foreign_key: { to_table: :teams }
      t.references :match, foreign_key: true

      t.timestamps
    end
  end
end
