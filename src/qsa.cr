# The Q(s,a) matrix from the maths supporting
# q-learning
#
class Qsa

  alias QsaValue = Float32
  alias QsaValuesIndexedByMove = Hash(Int32, QsaValue) 
  alias QsaValuesIndexedByStateAndMove = Hash(Int32, QsaValuesIndexedByMove) 
  @qsa :  QsaValuesIndexedByStateAndMove
  # @adjustments : Array(Float32)

  def initialize
    @qsa =  QsaValuesIndexedByStateAndMove.new
    @stats = {} of Symbol => Float32
    @adjustments = [] of Float64
  end

  def set(state, move, new_q)
    old_q = get(state, move)
    @qsa[state] ||= QsaValuesIndexedByMove.new
    @qsa[state][move] ||= new_q.to_f32
    log_adjustment(new_q, old_q)
    increment_sets
  end

  def get(state, move) : QsaValue
    safe_get_move(state, move)
  end

  def safe_get_move(state, move) : QsaValue
    safe_get_state(state)[move]? || 0.0_f32
  end

  def safe_get_state(state) : QsaValuesIndexedByMove
    @qsa[state]? || QsaValuesIndexedByMove.new
  end

  getter :qsa

  def qsa_non_trivial
    @qsa.reject{ |_state, svalue| svalue.select{ |_move, mvalue| mvalue.abs > 0.001 } .empty? }
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
      total += v_state.size # accumulating no of QsaValues in each state
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
