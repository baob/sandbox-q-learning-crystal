require "../../spec_helper"
require "../../../src/policy/win_random"

def policy
  Policy::WinRandom.policy
end

module Policy
  describe WinRandom do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
