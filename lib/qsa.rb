# The Q(s,a) matrix from the maths supporting
# q-learning
#
class Qsa
  def initialize
    @qsa = {}
    @stats = Hash.new(0)
  end

  def set(state, move, player, new_q)
    @qsa[state] ||= {}
    @qsa[state][move] ||= {}
    @qsa[state][move][player] = new_q
    increment_sets
  end

  def get(state, move, player)
    ((@qsa[state] || {})[move] || {})[player] || 0.0
  end

  def qsa
    @qsa
  end

  def qsa_non_trivial
    @qsa.reject{ |state, svalue| svalue.reject{ |move, mvalue| mvalue.select{ |player, pvalue| pvalue.abs > 0.001 } .empty? }.empty? }
  end

  def inspect
    "<Qsa:0x#{object_id.to_s(16)}"\
      " @stats=\"#{@stats}\""\
      " states.count=\"#{@qsa.values.count}\""\
      " values.count=\"#{values_count}\""\
    '>'
  end

  def values_count
    @qsa.reduce(0) do |total, (k_state, v_state)|
      v_state_size = v_state.reduce(0) do |total, (k_action, v_action)|
        total += v_action.size # accumulating no players in each action
        total
      end
      total += v_state_size # accumulating no players in each state
      total
    end
  end

  def increment_sets
    @stats[:sets] += 1
  end

end
