require "../../../src/policy/q_learning"

module Policy
  describe QLearning do

    subject { described_class.new }

    it_behaves_like "any policy"

  end
end
