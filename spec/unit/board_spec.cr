require "../../src/board"

describe Board do
  let(:board0) { described_class.new }
  
  context "when empty" do
    subject { board0 }

    describe "#move_options" do
      it { expect(subject.move_options).to match_array(0..8) }
    end

    describe "#to_state" do
      it { expect(subject.to_state).to eq(0) }
    end
  end

  context "after player 1 moves to position 8" do
    let(:board1) { board0.apply_move(8, 1) }
    subject { board1 }

    describe "#move_options" do
      it { expect(subject.move_options).to match_array(0..7) }
    end

    describe "#to_state" do
      it { expect(subject.to_state).to eq(1) }
    end

    context "after player 2 moves to position 7" do
      let(:board2) { board1.apply_move(7, 2) }
      subject { board2 }

      describe "#move_options" do
        it { expect(subject.move_options).to match_array(0..6) }
      end

      describe "#to_state" do
        it { expect(subject.to_state).to eq(7) } # 2*3 + 1
      end

      context "after player 1 moves to position 6" do
        let(:board3) { board2.apply_move(6, 1) }
        subject { board3 }

        describe "#move_options" do
          it { expect(subject.move_options).to match_array(0..5) }
        end

        describe "#to_state" do
          it { expect(subject.to_state).to eq(1 * 3**2 + 2 * 3**1 + 1 * 3**0) }
        end

        context "after player 2 moves to position 0" do
          let(:board4) { board3.apply_move(0, 2) }
          subject { board4 }

          describe "#move_options" do
            it { expect(subject.move_options).to match_array(1..5) }
          end

          describe "#to_state" do
            it { expect(subject.to_state).to eq(2 * 3**8 + 1 * 3**2 + 2 * 3**1 + 1 * 3**0) }
          end

          it "board is equal to another board created from #to_state" do
            is_expected.to eq(Board.from_state(subject.to_state))
          end

          it "board is equal to another board created from #to_a" do
            is_expected.to eq(Board.new(subject.to_a))
          end

          describe "#to_a" do
            it { expect(subject.to_a).to match([2, 0, 0, 0, 0, 0, 1, 2, 1]) }
          end

          describe "#to_s" do
            it { expect(subject.to_s).to  eq("2..\n...\n121\n") }
          end

          describe "#to_s(\'OX\')" do
            it { expect(subject.to_s("OX")).to eq("X..\n...\nOXO\n") }
          end

        end

      end

    end

  end
end
