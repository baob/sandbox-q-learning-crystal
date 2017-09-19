require 'board'

RSpec.describe Board do
  let(:board0) { described_class.new }

  context 'when empty' do
    subject { board0 }

    describe '#move_options' do
      specify { expect(subject.move_options).to match_array(0..8) }
    end

    describe '#to_state' do
      specify { expect(subject.to_state).to eq(0) }
    end
  end

  context 'after player 1 moves to position 8' do
    let(:board1) { board0.apply_move(8,1) }
    subject { board1 }

    describe '#move_options' do
      specify { expect(subject.move_options).to match_array(0..7) }
    end

    describe '#to_state' do
      specify { expect(subject.to_state).to eq(1) }
    end

    context 'after player 2 moves to position 7' do
      let(:board2) { board1.apply_move(7,2) }
      subject { board2 }

      describe '#move_options' do
        specify { expect(subject.move_options).to match_array(0..6) }
      end

      describe '#to_state' do
        specify { expect(subject.to_state).to eq(7) } # 2*3 + 1
      end


      context 'after player 1 moves to position 6' do
        let(:board3) { board2.apply_move(6,1) }
        subject { board3 }

        describe '#move_options' do
          specify { expect(subject.move_options).to match_array(0..5) }
        end

        describe '#to_state' do
          specify { expect(subject.to_state).to eq(1*3**2 + 2*3**1 + 1*3**0) }
        end

      end

    end

  end
end
