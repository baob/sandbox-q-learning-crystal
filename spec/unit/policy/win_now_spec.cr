require "../../../src/policy/win_now"

def policy
  Policy::WinNow
end
module Policy
  describe WinNow do

    # subject { described_class }

    it_behaves_like_any_policy(policy)

  end
end
