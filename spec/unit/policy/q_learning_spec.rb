require 'policy/q_learning'

module Policy
  RSpec.describe QLearning do

    subject { described_class.new }

    it_behaves_like 'any policy'

  end
end
