require "../spec_helper"
require "../../src/qsa"

def qsa 
  Qsa.new
end

def qsa_set(state, move, value)
  q = Qsa.new
  q.set(state, move, value)
  q
end

describe Qsa do
  
  context "when empty" do

    it "returns 0.0 for any get" do
      qsa.get(99,2).should eq(0.0_f32)
    end
  end

  context "when a value has been set" do
    it "returns the same value" do
      q = qsa_set(5, 6, 0.5)
      q.get(5, 6).should eq(0.5_f32)
    end

    it "returns 0.0 for other move" do
      q = qsa_set(5, 6, 0.5)
      q.get(5, 7).should eq(0.0_f32)
    end

    it "returns 0.0 for other state" do
      q = qsa_set(5, 6, 0.5)
      q.get(4, 6).should eq(0.0_f32)
    end
  end
end
  