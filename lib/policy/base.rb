module Policy
  class Base
    class << self

      def play(board, as_player)
        moves = move_options(board)
        move = chosen_move(board, as_player, moves)
        new_board = board.apply_move(move, as_player)
      end

      def chosen_move(board, player, moves)
        raise NotImplementedError # Implement in sub-classes
      end

      def move_options(board)
        board.move_options
      end

      def play_best(*args)
        play(*args)
      end

    end
  end
end
