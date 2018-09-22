require "policy/random"

module Policy
  RSpec.describe Random do

    subject { described_class }

    it_behaves_like "any policy"

  end
end
