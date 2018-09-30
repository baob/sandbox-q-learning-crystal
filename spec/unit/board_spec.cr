require "../spec_helper"
require "../../src/board"

def board0 
  Board.new(nil)
end

def board1
  board0.apply_move(8, 1)
end

def board2
  board1.apply_move(7, 2) 
end

def board3
  board2.apply_move(6, 1)
end

def board4
  board3.apply_move(0, 2)
end

describe Board do
  # let(:board0) { described_class.new }

  context "when empty" do
    # subject { board0 }

    describe "#move_options" do
      it { (board0.move_options).should eq((0..8).to_a) }
    end

    describe "#to_state" do
      it { (board0.to_state).should eq(0) }
    end
  end

  context "after player 1 moves to position 8" do
    # let(:board1) { board0.apply_move(8, 1) }
    # subject { board1 }

    describe "#move_options" do
      it { (board1.move_options).should eq((0..7).to_a) }
    end

    describe "#to_state" do
      it { (board1.to_state).should eq(1) }
    end

    context "after player 2 moves to position 7" do
      # let(:board2) { board1.apply_move(7, 2) }
      # subject { board2 }

      describe "#move_options" do
        it { (board2.move_options).should eq((0..6).to_a) }
      end

      describe "#to_state" do
        it { (board2.to_state).should eq(7) } # 2*3 + 1
      end

      context "after player 1 moves to position 6" do
        # let(:board3) { board2.apply_move(6, 1) }
        # subject { board3 }

        describe "#move_options" do
          it { (board3.move_options).should eq((0..5).to_a) }
        end

        describe "#to_state" do
          it { (board3.to_state).should eq(1 * 3**2 + 2 * 3**1 + 1 * 3**0) }
        end

        context "after player 2 moves to position 0" do
          # let(:board4) { board3.apply_move(0, 2) }
          # subject { board4 }

          describe "#move_options" do
            it { (board4.move_options).should eq((1..5).to_a) }
          end

          describe "#to_state" do
            it { (board4.to_state).should eq(2 * 3**8 + 1 * 3**2 + 2 * 3**1 + 1 * 3**0) }
          end

          it "board is equal to another board created from #to_state" do
            board4.should eq(Board.from_state(board4.to_state))
          end

          it "board is equal to another board created from #to_a" do
            board4.should eq(Board.new(board4.to_a))
          end

          describe "#to_a" do
            it { (board4.to_a).should eq([2, 0, 0, 0, 0, 0, 1, 2, 1]) }
          end

          describe "#to_s" do
            it { (board4.to_s).should  eq("2..\n...\n121\n") }
          end

          describe "#to_s(\'OX\')" do
            it { (board4.to_s("OX")).should eq("X..\n...\nOXO\n") }
          end

        end

      end

    end

  end
end