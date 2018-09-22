# The Q(s,a) matrix from the maths supporting
# q-learning
# extended with an extra dimension to support two players
#
class Qsa
  def initialize
    @qsa = {} of Int32 => Dictionary
    @stats = {} of Symbol => Fixnum
    @adjustments = [] of Int32
  end

  def set(state, move, player, new_q)
    old_q = get(state, move, player)
    @qsa[state] ||= {} of Int32 => Dictionary
    @qsa[state][move] ||= {} of Int32 => Dictionary
    @qsa[state][move][player] = new_q
    log_adjustment(new_q, old_q)
    increment_sets
  end

  def get(state, move, player)
    ((@qsa[state] || {} of Int32 => Dictionary)[move] || {} of Int32 => Dictionary)[player] || 0.0
  end

  attr_reader :qsa

  def qsa_non_trivial
    @qsa.reject{ |_state, svalue| svalue.reject{ |_move, mvalue| mvalue.select{ |_player, pvalue| pvalue.abs > 0.001 } .empty? }.empty? }
  end

  def inspect
    "<Qsa:0x#{object_id.to_s(16)}"\
      " @stats=\"#{@stats}\""\
      " states.count=\"#{@qsa.values.count}\""\
      " values.count=\"#{values_count}\""\
      " adjustments.max=\"#{@adjustments.max}\""\
      " adjustments.mean=\"#{mean_adjustments}\""\
    ">"
  end

  def values_count
    @qsa.reduce(0) do |total, (_k_state, v_state)|
      v_state_size = v_state.reduce(0) do |total, (_k_action, v_action)|
        total += v_action.size # accumulating no players in each action
        total
      end
      total += v_state_size # accumulating no players in each state
      total
    end
  end

  def log_adjustment(new_q, old_q)
    @adjustments.unshift((new_q - old_q).abs)
    @adjustments = @adjustments[0..99] if @adjustments.size > 100
  end

  def mean_adjustments
    @adjustments.compact.reduce(&:+) / @adjustments.compact.size

  end

  def increment_sets
    @stats[:sets] += 1
  end

end
