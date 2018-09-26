require "../../spec_helper"
require "../../../src/policy/random"

def policy
  Policy::Random.policy
end

module Policy
  describe Random do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
