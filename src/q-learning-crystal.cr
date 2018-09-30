# TODO: Write documentation for `Q::Learning::Crystal`
require "./series"
module Q::Learning::Crystal
  VERSION = "0.1.0"

  # TODO: Put your code here
  # $ irb -I lib -r series
  # > ql = Policy::QLearning.new # set up our untrained q-learning 'policy'
  # > Game.new(ql, Policy::WinRandom, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)
  # > Series.new(ql, Policy::WinRandom, 500).play  # to run a training series

  # Date:   Sat Sep 9 00:16:21 2017 0100

  # For future ref, it looks like optimal 'training'
  # is acheived with 50K - 300K games against varied
  # opponents (including the completely random) with the
  # explore % set high (say 90%) and the learning rate
  # varing from 0.5 to 0.01 (to force convergence). Other
  # strategies (e.g. learning rate 0.9 against consistent
  # non-random opponent) can lead to convergence on
  # suboptimal solutions.


  ql = Policy::QLearning.policy # set up our untrained q-learning 'policy'
  ql.discount = 0.95
  ql.explore_percent = 99

  ql.learning_rate = 0.2

  # ql.learning_rate = 0.512
  Series.new(ql, Policy::WinRandom.policy, 20000).play  # to run a training series
  ql.assess

  # ql.learning_rate = 0.256
  Series.new(ql, Policy::WinRandom.policy, 40000).play  # to run a training series
  ql.assess

  # ql.learning_rate = 0.128
  Series.new(ql, Policy::WinRandom.policy, 80000).play  # to run a training series
  ql.assess

  # ql.learning_rate = 0.064
  Series.new(ql, Policy::WinRandom.policy, 160000).play  # to run a training series
  ql.assess

  # ql.learning_rate = 0.032
  Series.new(ql, Policy::WinRandom.policy, 320000).play  # to run a training series
  ql.assess

  ql.trace = true
  Game.new(ql, Policy::WinRandom.policy, trace: true).play_best  # to see one game (q-learning versus good-but-a-bit-random)

  
  # Indicators of training success:
end
