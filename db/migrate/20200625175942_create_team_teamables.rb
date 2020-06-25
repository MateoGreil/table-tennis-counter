class CreateTeamTeamables < ActiveRecord::Migration[6.0]
  def change
    create_table :team_teamables do |t|
      t.references :teamable, null: false, polymorphic: true
      t.references :teams, null: false
      t.integer :score

      t.timestamps
    end
  end
end
