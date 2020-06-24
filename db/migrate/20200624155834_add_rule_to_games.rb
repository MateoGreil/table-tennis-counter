class AddRuleToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :rule, :integer
  end
end
