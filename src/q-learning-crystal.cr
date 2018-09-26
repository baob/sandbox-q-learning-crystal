# TODO: Write documentation for `Q::Learning::Crystal`
require "./series"
module Q::Learning::Crystal
  VERSION = "0.1.0"

  # TODO: Put your code here
  # $ irb -I lib -r series
  # > ql = Policy::QLearning.new # set up our untrained q-learning 'policy'
  # > Game.new(ql, Policy::WinRandom, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  # > Series.new(ql, Policy::WinRandom, 500).play  # to run a training series


  ql = Policy::QLearning.new # set up our untrained q-learning 'policy'
  Game.new(ql, Policy::WinRandom, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  Series.new(ql, Policy::WinRandom, 500).play  # to run a training series

  # Indicators of training success:

  # ql.qsa.inspect shows decreasing adjustments => convergence

  # Stats at end of series indicate high number of draws or
  # wins for QL player

  # ql.qsa.qsa[0] shows a preference (higher Q) for opening with a
  # corner play (moves 0, 2, 6 and 8). Can also check this with
  # puts ql.play(Board.new, 1).to_s

  # ql.qsa.inspect shows nearing 4520 different states and 16165 distinct
  # q-values

  puts  "\nshows decreasing adjustments => convergence ?"
  puts "shows nearing 4520 different states and 16165 distinct q-values ?"
  puts ql.qsa.inspect

  puts  "\nql.qsa.qsa[0] shows a preference (higher Q) for opening with a corner play (moves 0, 2, 6 and 8) ?"
  puts ql.qsa.qsa[0]

end
