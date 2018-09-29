require "./series"


class QAdjustmentDebug
end

# TODO: Write documentation for `Q::Learning::Crystal`
require "./series"
module Q::Learning::Crystal
  VERSION = "0.1.0"

  ql = Policy::QLearning.policy(trace: true) # set up our untrained q-learning 'policy'
  ql.discount = 0.9
  ql.explore_percent = 90

  ql.learning_rate = 0.512
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)

  ql.trace = false
  Series.new(ql, Policy::WinRandom.policy, 10).play  # to run a training series

  ql.trace = true
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)

  ql.assess


  
  # Indicators of training success:
end
