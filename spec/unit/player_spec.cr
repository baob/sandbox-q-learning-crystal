require "../spec_helper"
require "../../src/player"
require "../../src/policy/win_now"

def player
  Player.new(policy: Policy::WinNow.new, token: "X", number: 2)
end

describe Player do

  context "initialized" do
    # subject { Player.new(policy: :the_policy, token: "X", number: 2) }
    it { player.responds_to?(:policy).should be_true }
    it { player.responds_to?(:token).should be_true }
    it { player.responds_to?(:number).should be_true }
  end

end
