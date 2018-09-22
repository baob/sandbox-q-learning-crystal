module Policy
  class Base
    # class << self

      def self.play(board, as_player)
        moves = move_options(board)
        move = chosen_move(board, as_player, moves)
        new_board = board.apply_move(move, as_player)
      end

      def self.chosen_move(_board, _player, _moves)
        raise NotImplementedError # Implement in sub-classes
      end

      def self.move_options(board)
        board.move_options
      end

      def self.play_best(*args)
        play(*args)
      end

    # end
  end
end
