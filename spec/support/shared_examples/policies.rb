shared_examples_for 'any policy' do
  context 'with a valid board' do
    let(:board) { Board.new }

    it 'returns a new valid board' do
      expect(subject.play(board, 1)).to be_kind_of(Board)
    end
  end
end
