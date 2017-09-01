require 'board'
require_relative 'base'
require 'qsa'

module Policy
  class QLearning < Base

    attr_accessor :explore_percent, :learning_rate, :discount

    def initialize
      @explore_percent = 67
      @learning_rate = 0.8
      @discount = 0.9
      @qsa = Qsa.new
    end

    def play(board, as_player)
      moves = self.class.move_options(board)

      if exploring?
        move = choose_exploring_move(board, as_player, moves)
        new_board = board.apply_move(move, as_player)
      else
        move = choose_exploiting_move(board, as_player, moves)
        new_board = board.apply_move(move, as_player)
        recalculate_q(board, move, new_board, as_player)
        new_board
      end
    end

    def choose_exploiting_move(board, player, moves)
      return moves.first if moves.size == 1
      moves.max { |move1, move2| qba_get_net(board, move1, player) <=> qba_get_net(board, move2, player) }
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
      '>'
    end

    def qsa_non_trivial
      qsa.qsa_non_trivial
    end

    private

    attr_reader :qsa

    def exploring?
      rand(100) < @explore_percent
    end

    def recalculate_q(board, move, new_board, player)
      new_q = (1.0 - @learning_rate) * qba_get(board, move, player)  +
              @learning_rate * ( reward(new_board, player) + @discount * value(new_board, player) )
      qba_set(board, move, player, new_q)
    end

    def qba_get_net(board, move, player)
      state = state_from_board(board)
      qsa.get(state, move, player) - qsa.get(state, move, other_player(player))
    end

    def qba_get(board, move, player)
      state = state_from_board(board)
      qsa.get(state, move, player)
    end

    def qba_set(board, move, player, new_q)
      state = state_from_board(board)
      qsa.set(state, move, player, new_q)
    end

    def state_from_board(board)
      board.to_state
    end

    def reward(board, player)
      if board.is_win_for?(player)
        return 1.0
      elsif board.is_win_for?(other_player(player))
        return -1.0
      elsif board.game_over?
        return 0.0
      else
        return -0.05
      end
    end

    def value(board, player)
      board.move_options.map{ |move| qba_get_net(board, move, player) }.max || 0.0
    end

    def other_player(player)
      3 - player
    end

  end
end
