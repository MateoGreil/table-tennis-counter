# first_team          :references   not null
# second_team         :references   not null
# winner              :references
# first_team_points   :references   not null  default: 0
# second_team_points  :references   not null  default: 0
# rule                :integer      not null
# games_rule          :integer      not null
class Match < ApplicationRecord
  enum rule: %i[3 5]
  enum games_rule: Game.rules.keys

  belongs_to :first_team, class_name: 'Team', dependent: :destroy
  belongs_to :second_team, class_name: 'Team', dependent: :destroy
  belongs_to :winner, class_name: 'Team', optional: true

  has_many :games, dependent: :destroy

  accepts_nested_attributes_for :first_team, :second_team, :games

  before_validation :fill_games

  after_validation :set_team_points

  before_save :set_winner, if: :there_is_a_winner?

  def first_team_status
    if winner.nil?
      :in_progress
    elsif winner == first_team
      :winner
    else
      :looser
    end
  end

  def second_team_status
    if winner.nil?
      :in_progress
    elsif winner == second_team
      :winner
    else
      :looser
    end
  end

  private

  def fill_games
    games.each_with_index do |game, index|
      game.first_team = first_team
      game.second_team = second_team
      game.rule = games_rule
      game.round = index
    end
  end

  def set_team_points
    self.first_team_points = games.where(winner: first_team).length
    self.second_team_points = games.where(winner: second_team).length
  end

  def there_is_a_winner?
    if first_team_points + second_team_points == rule.to_i ||
       first_team_points > rule.to_i / 2 ||
       second_team_points > rule.to_i / 2
      return true
    end

    false
  end

  def set_winner
    self.winner = if first_team_points > second_team_points
                    first_team
                  else
                    second_team
                  end
  end

end
