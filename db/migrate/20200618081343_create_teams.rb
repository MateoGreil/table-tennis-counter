class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.references :teamable, null: false, polymorphic: true
      t.integer :score

      t.timestamps
    end
  end
end
