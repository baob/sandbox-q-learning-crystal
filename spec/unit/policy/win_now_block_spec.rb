require 'policy/win_now_block'

module Policy
  RSpec.describe WinNowBlock do

    subject { described_class }

    it_behaves_like 'any policy'

  end
end
