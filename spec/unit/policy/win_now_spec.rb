require 'policy/win_now'

module Policy
  RSpec.describe WinNow do

    subject { described_class }

    it_behaves_like 'any policy'

  end
end
