require "spec"
# require "minitest/autorun"

def board
    Board.new
end

def it_behaves_like_any_policy(policy)
    context "with a valid board" do
        # let(:board) { Board.new }
    
        describe "#play" do
          it "returns a new valid board" do
            (policy.play(board, 1)).should be_a(Board)
          end
        end
    
        describe "#play_best" do
          it "returns a new valid board" do
            (policy.play_best(board, 1)).should be_a(Board)
          end
        end
      end
    
end

