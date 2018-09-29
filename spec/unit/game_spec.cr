require "../spec_helper"
require "../../src/game"

def policy_a
  Policy::WinNow.policy
end

def policy_b
  Policy::WinNow.policy
end

def game
  Game.new(policy_a, policy_b)
end

describe Game do

  it "can be initialised turning off trace" do
    Game.new(policy_a, policy_b, trace: false)
  end

  context "initialized" do
    it { game.responds_to?(:play).should be_true}
    it { game.responds_to?(:play_best).should be_true}
  end
end