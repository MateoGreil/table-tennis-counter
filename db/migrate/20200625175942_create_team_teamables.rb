class CreateTeamTeamables < ActiveRecord::Migration[6.0]
  def change
    create_table :team_teamables do |t|
      t.references :teamable, null: false, polymorphic: true
      t.references :team, null: false
      t.integer :score, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
