require "game"

# Runs a series of games silently, then 100 more
# at best possible play (versus q-learning exploring)
# to evaluate effectiveness.

class Series

  attr_reader :player_a_policy, :player_b_policy, :repeats, :trace, :stats

  def initialize(player_a_policy, player_b_policy, repeats, trace: false)
    @player_a_policy = player_a_policy
    @player_b_policy = player_b_policy
    @repeats = repeats
    @trace = trace
    @stats = Hash.new(0)
  end

  def play
    repeats.times { Game.new(player_a_policy, player_b_policy, trace: trace).play }

    evaluation_count.times do

      player = Game.new(player_a_policy, player_b_policy, trace: trace).play_best
      if player.nil?
        stats[:draws] += 1
      else
        if player.policy == player_a_policy
          stats[:player_a] += 1
        else
          stats[:player_b] += 1
        end
      end
    end

    puts "Stats: #{stats.sort.map{ |x| x.join(': ')}.join(', ')}"
  end

  def evaluation_count
    100
  end
end
