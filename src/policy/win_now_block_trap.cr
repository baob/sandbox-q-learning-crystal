require "./win_now_block_naive_line"

module Policy
  class WinNowBlockTrap < WinNowBlockNaiveLine

    # class << self

      def self.chosen_move(board, player, moves)
        winning_move(board, player, moves) ||
          blocking_move(board, player, moves) ||
          trap_move(board, player, moves) ||
          naive_line_move(board, player, moves) ||
          random_move(moves)
      end

      def self.trap_move(board, player, moves)
        moves = trap_moves(board, player, moves)
        moves.empty? ? nil : moves.sample
      end

      # Choose lines that offer 2 winning moves next time
      #
      def self.trap_moves(board, player, moves)
        moves.select do |move|
          new_board = board.apply_move(move, player)
          winning_moves_for(new_board, player, new_board.move_options).size >= 2
        end
      end

    # end

  end
end
