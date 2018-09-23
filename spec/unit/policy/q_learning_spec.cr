require "../../spec_helper"
require "../../../src/policy/q_learning"

def policy
  Policy::QLearning.new
end

# it_behaves_like_any_policy(policy)
# module Policy
  describe Policy::QLearning do

    # subject { described_class.new }

    # it_behaves_like "any policy"
    it_behaves_like_any_policy(policy)

  end
# end
