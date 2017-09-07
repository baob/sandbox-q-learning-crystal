# Runs a series of games silently, then 1000 more to
# evaluate effectiveness.
# explore_percent is set to 0 for the evaluation
# needs to be manually reset for another series
# TODO: improve on this ^
#
require 'game'

class Series

  attr_reader :player_1_policy, :player_2_policy, :repeats, :trace, :stats

  def initialize(player_1_policy, player_2_policy, repeats, trace: false)
    @player_1_policy = player_1_policy
    @player_2_policy = player_2_policy
    @repeats = repeats
    @trace = trace
    @stats = Hash.new(0)
  end

  def play
    repeats.times { Game.new(player_1_policy, player_2_policy, trace: trace).play }

    [player_1_policy, player_2_policy].each do |policy|
      policy.explore_percent = -1 if policy.respond_to?(:explore_percent)
    end

    evaluation_count.times do

      player = Game.new(player_1_policy, player_2_policy, trace: trace).play
      if player.nil?
        stats[:draws] += 1
      else
        if player.policy == player_1_policy
          stats[:player_1] += 1
        else
          stats[:player_2] += 1
        end
      end
    end

    puts "Stats: #{stats.sort}"
  end

  def evaluation_count
    100
  end
end
