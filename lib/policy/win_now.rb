require "board"
require "policy/random"

module Policy
  class WinNow < Random
    class << self

      def chosen_move(board, player, moves)
        winning_move(board, player, moves) || random_move(moves)
      end

      private

      def winning_move(board, player, moves)
        winning_moves_for(board, player, moves).sample
      end

      def winning_moves_for(board, player, moves)
        moves.select do |move|
          board.apply_move(move, player).is_win_for?(player)
        end
      end
    end

  end
end
