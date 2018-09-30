require "./series"

# TODO: Write documentation for `Q::Learning::Crystal`
require "./series"

module QAdjustmentDebug
  VERSION = "0.1.0"

  ql = Policy::QLearning.policy(trace: true) # set up our untrained q-learning 'policy'
  ql.discount = 0.9
  ql.explore_percent = 90

  ql.learning_rate = 0.1
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)

  puts "ql.qsa.qsa.inspect: ------- \n #{ql.qsa.qsa.inspect}"



  ql.trace = false
  Series.new(ql, Policy::WinRandom.policy, 100).play  # to run a training series

  puts "ql.qsa.qsa.inspect: ------- \n #{ql.qsa.qsa.inspect}"

  Series.new(ql, Policy::WinRandom.policy, 100000).play  # to run a training series

  ql.trace = true
  Game.new(ql, Policy::WinRandom.policy, trace: true).play  # to see one game (q-learning versus good-but-a-bit-random)

  ql.assess

  # puts "ql.qsa.qsa_non_trivial.inspect: ------- \n #{ql.qsa.qsa.inspect}"


  
  # Indicators of training success:
end
