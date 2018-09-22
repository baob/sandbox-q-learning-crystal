require "policy/win_now_block_trap"

module Policy
  RSpec.describe WinNowBlockTrap do

    subject { described_class }

    it_behaves_like "any policy"

  end
end
