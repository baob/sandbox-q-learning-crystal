# TODO: Write documentation for `Q::Learning::Crystal`
require "./series"
module Q::Learning::Crystal
  VERSION = "0.1.0"

  # TODO: Put your code here
  # $ irb -I lib -r series
  # > ql = Policy::QLearning.new # set up our untrained q-learning 'policy'
  # > Game.new(ql, Policy::WinRandom, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  # > Series.new(ql, Policy::WinRandom, 500).play  # to run a training series


  ql = Policy::QLearning.policy # set up our untrained q-learning 'policy'
  ql.learning_rate = 0.1
  ql.discount = 0.3
  ql.explore_percent = 67
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  Series.new(ql, Policy::WinRandom.policy, 100000).play  # to run a training series
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  Series.new(ql, Policy::Random.policy, 50000).play  # to run a training series
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  
  # Indicators of training success:
  ql.assess
end
