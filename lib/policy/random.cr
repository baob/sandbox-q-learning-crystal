require "board"
require "policy/base"

module Policy
  class Random < Base
    class << self

      def chosen_move(_board, _player, moves)
        random_move(moves)
      end

      private

      def random_move(moves)
        moves.sample
      end
    end

  end
end
