require "../spec_helper"
require "../../src/qsa"

def qsa 
  Qsa.new
end


describe Qsa do
  
  context "when empty" do

    it "returns 0.0 for any get" do
        qsa.get(99,2,8888).should eq(0.0_f32)
    end
  end
end
  