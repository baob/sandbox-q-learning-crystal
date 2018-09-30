require "../../spec_helper"
require "../../../src/policy/win_now_block_naive_line"

def policy
  Policy::WinNowBlockNaiveLine.policy
end

module Policy
  describe WinNowBlockNaiveLine do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
