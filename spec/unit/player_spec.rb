require "player"

RSpec.describe Player do

  context "initialized" do
    subject { Player.new(policy: :the_policy, token: "X", number: 2) }

    it { is_expected.to respond_to(:policy) }
    it { is_expected.to respond_to(:token) }
    it { is_expected.to respond_to(:number) }
  end

end
