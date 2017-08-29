require 'board'

RSpec.describe Board do
  context 'when empty' do
    subject { described_class.new }

    describe '#move_options' do
      specify { expect(subject.move_options).to match_array(0..8) }
    end
  end
end
