require "../board"
require "./random"

module Policy
  class WinNow < Random

    def self.policy
      new
    end
    
    # class << self

      def chosen_move(board, player, moves)
        winning_move(board, player, moves) || random_move(moves)
      end

      # private

      private def winning_move(board, player, moves)
        moves = winning_moves_for(board, player, moves)
        moves.empty? ? nil : moves.sample
      end

      private def winning_moves_for(board, player, moves)
        moves.select do |move|
          board.apply_move(move, player).is_win_for?(player)
        end
      end
    # end

  end
end
