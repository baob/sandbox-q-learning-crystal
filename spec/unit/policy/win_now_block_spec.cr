require "../../spec_helper"
require "../../../src/policy/win_now_block"

def policy
  Policy::WinNowBlock.policy
end

module Policy
  describe WinNowBlock do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
