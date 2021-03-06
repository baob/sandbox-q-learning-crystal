# The Q(s,a) matrix from the maths supporting
# q-learning
# extended with an extra dimension to support two players
#
class Qsa

  alias QsaValue = Float32
  alias QsaValuesIndexedByPlayer = Hash(Int32, QsaValue) 
  alias QsaValuesIndexedByMoveAndPlayer = Hash(Int32, QsaValuesIndexedByPlayer) 
  alias QsaValuesIndexedByStateMoveAndPlayer = Hash(Int32, QsaValuesIndexedByMoveAndPlayer) 
  @qsa :  QsaValuesIndexedByStateMoveAndPlayer
  # @adjustments : Array(Float32)

  def initialize
    @qsa =  QsaValuesIndexedByStateMoveAndPlayer.new
    @stats = {} of Symbol => Float32
    @adjustments = [] of Float64
  end

  def set(state, move, player, new_q)
    old_q = get(state, move, player)
    @qsa[state] ||= QsaValuesIndexedByMoveAndPlayer.new
    @qsa[state][move] ||= QsaValuesIndexedByPlayer.new
    @qsa[state][move][player] = new_q.to_f32
    log_adjustment(new_q, old_q)
    increment_sets
  end

  def get(state, move, player) : QsaValue
    get_qsa_value_indexed_by_player(state, move, player)
  end

  def get_qsa_value_indexed_by_player(state, move, player) : QsaValue
    safe_get_move(state, move)[player]? || 0.0_f32
  end

  def safe_get_move(state, move) : QsaValuesIndexedByPlayer
    safe_get_state(state)[move]? || QsaValuesIndexedByPlayer.new
  end

  def safe_get_state(state) : QsaValuesIndexedByMoveAndPlayer
    @qsa[state]? || QsaValuesIndexedByMoveAndPlayer.new
  end

  getter :qsa

  def qsa_non_trivial
    @qsa.reject{ |_state, svalue| svalue.reject{ |_move, mvalue| mvalue.select{ |_player, pvalue| pvalue.abs > 0.001 } .empty? }.empty? }
  end

  def inspect
    "<Qsa:0x#{object_id.to_s(16)}"\
      " @stats=\"#{@stats}\""\
      " states.count=\"#{@qsa.values.size}\""\
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
    @adjustments.compact.reduce(&.+) / @adjustments.compact.size

  end

  def increment_sets
    @stats[:sets] ||= 0
    @stats[:sets] += 1
  end

end
