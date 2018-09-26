require "../../spec_helper"
require "../../../src/policy/win_now_block_trap"

def policy
  Policy::WinNowBlockTrap.policy
end

module Policy
  describe WinNowBlockTrap do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
