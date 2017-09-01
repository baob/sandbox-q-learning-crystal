# The Q(s,a) matrix from the maths supporting
# q-learning
#
class Qsa
  def initialize
    @qsa = {}
  end

  def set(state, move, player, new_q)
    @qsa[state] ||= {}
    @qsa[state][move] ||= {}
    @qsa[state][move][player] = new_q
  end

  def get(state, move, player)
    @qsa[state] ||= {}
    @qsa[state][move] ||= {}
    @qsa[state][move][player] || 0.0
  end

  def qsa
    @qsa
  end

  def qsa_non_trivial
    @qsa.reject{ |state, svalue| svalue.reject{ |move, mvalue| mvalue.select{ |player, pvalue| pvalue.abs > 0.001 } .empty? }.empty? }
  end

  def inspect
    "<Qsa:0x#{object_id.to_s(16)}"\
    '>'
  end

end
