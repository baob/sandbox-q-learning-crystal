require "board"
require_relative "base"
require "qsa"

module Policy
  class QLearning < Base

    attr_accessor :explore_percent, :learning_rate, :discount

    def initialize

      # Date:   Sat Sep 9 00:16:21 2017 +0100

      # For future ref, it looks like optimal 'training'
      # is acheived with 50K - 300K games against varied
      # opponents (including the completely random) with the
      # explore % set high (say 90%) and the learning rate
      # varing from 0.5 to 0.01 (to force convergence). Other
      # strategies (e.g. learning rate 0.9 against consistent
      # non-random opponent) can lead to convergence on
      # suboptimal solutions.

      @explore_percent = 90
      @learning_rate = 0.5
      @discount = 0.9
      @qsa = Qsa.new
    end

    def play(board, as_player)
      play_generic(board, as_player) do |moves|
        if exploring?
          choose_exploring_move(board, as_player, moves)
        else
          choose_exploiting_move(board, as_player, moves)
        end
      end
    end

    def play_best(board, as_player)
      play_generic(board, as_player) do |moves|
        choose_exploiting_move(board, as_player, moves)
      end
    end

    def choose_exploiting_move(board, player, moves)
      return moves.first if moves.size == 1
      moves.max { |move1, move2| total_qsa_get_for_board(board, move1, player) <=> total_qsa_get_for_board(board, move2, player) }
    end

    def choose_exploring_move(board, player, moves)
      return moves.first if moves.size == 1
      exploring_moves = moves.dup
      exploring_moves.delete(choose_exploiting_move(board, player, moves))
      exploring_moves.sample
    end

    def inspect
      "<Policy::QLearning:0x#{object_id.to_s(16)}"\
      " explore_percent=\"#{@explore_percent}\""\
      " learning_rate=\"#{@learning_rate}\""\
      " discount=\"#{@discount}\""\
      ">"
    end

    attr_reader :qsa

    private

    def play_generic(board, as_player)
      moves = self.class.move_options(board)

      move = yield moves

      new_board = board.apply_move(move, as_player)
      recalculate_q(board, move, new_board, as_player)
      new_board
    end

    def exploring?
      rand(100) < @explore_percent
    end

    def recalculate_q(board, move, new_board, player)
      new_q = (1.0 - @learning_rate) * qsa_get_for_board(board, move, player) +
              @learning_rate * (reward(new_board, player) + @discount * value(new_board, player))
      qsa_set_for_board(board, move, player, new_q)
    end

    def total_qsa_get_for_board(board, move, player)
      state = state_from_board(board)

      # TODO: This may be mistaken. Either "I" move or "they" do,
      #       so it doesn't make sense to combine "I" and "they" values.
      # generalise to N players, move to QSA then write specs.
      # Maybe the answer is: If "I" have qsa values, take the max of those.
      #           otherwise: If "they" gave qsa value take the min (or max) of -ve of those
      qsa.get(state, move, player) - qsa.get(state, move, other_player(player))
    end

    def qsa_get_for_board(board, move, player)
      state = state_from_board(board)
      qsa.get(state, move, player)
    end

    def qsa_set_for_board(board, move, player, new_q)
      state = state_from_board(board)
      qsa.set(state, move, player, new_q)
    end

    def state_from_board(board)
      board.to_state
    end

    def reward(board, player)
      if board.is_win_for?(player)
        1.0
      elsif board.next_time_is_win_for?(other_player(player))
        -1.0
      elsif board.next_time_could_be_win_for?(other_player(player))
        -1.0
      elsif board.game_over?
        0.2
      elsif board.next_time_is_game_over?
        0.2
      else
        -0.1
      end
    end

    def value(board, player)
      board.move_options.map{ |move| total_qsa_get_for_board(board, move, player) }.max || 0.0
    end

    def other_player(player)
      Board.other_player(player) # player number is either 1 or 2
    end

  end
end
