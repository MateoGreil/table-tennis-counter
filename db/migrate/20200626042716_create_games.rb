class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :rule, null: false
      t.references :first_team, null: false, foreign_key: { to_table: :teams }
      t.references :second_team, null: false, foreign_key: { to_table: :teams }
      t.references :winner, null: true, foreign_key: { to_table: :teams }
      t.integer :first_team_points, null: false, default: 0
      t.integer :second_team_points, null: false, default: 0
      t.references :match, foreign_key: true
      t.integer :round, null: true, default: nil

      t.timestamps
    end
  end
end
