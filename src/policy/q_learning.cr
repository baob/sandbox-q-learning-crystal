require "../board"
require "./base"
require "../qsa"

module Policy
  class QLearning < Base

    def self.policy
      new
    end
    

    property :explore_percent, :learning_rate, :discount

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
      moves.sort { |move1, move2| total_qsa_get_for_board(board, move1, player) <=> total_qsa_get_for_board(board, move2, player) }.last
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

    getter :qsa

    def assess

      # Indicators of training success:

      # ql.qsa.inspect shows decreasing adjustments => convergence

      # Stats at end of series indicate high number of draws or
      # wins for QL player

      # ql.qsa.qsa[0] shows a preference (higher Q) for opening with a
      # corner play (moves 0, 2, 6 and 8). Can also check this with
      # puts ql.play(Board.new, 1).to_s

      # ql.qsa.inspect shows nearing 4520 different states and 16165 distinct
      # q-values

      puts  "\nshows decreasing adjustments => convergence ?"
      puts "shows nearing 4520 different states and 16165 distinct q-values ?"
      puts qsa.inspect

      puts  "\nqsa.qsa[0] shows a preference (higher Q) for opening with a corner play (moves 0, 2, 6 and 8) ?"
      puts "qsa.qsa[0][0] #{qsa.qsa[0][0]}"
      puts "qsa.qsa[0][2] #{qsa.qsa[0][2]}"
      puts "qsa.qsa[0][6] #{qsa.qsa[0][6]}"
      puts "qsa.qsa[0][8] #{qsa.qsa[0][8]}"
      puts "..."
      puts "qsa.qsa[0][1] #{qsa.qsa[0][1]}"
      puts "qsa.qsa[0][3] #{qsa.qsa[0][3]}"
      puts "qsa.qsa[0][4] #{qsa.qsa[0][4]}"
      puts "qsa.qsa[0][5] #{qsa.qsa[0][5]}"
      puts "qsa.qsa[0][7] #{qsa.qsa[0][7]}"
    end

    # private

    private def play_generic(board, as_player)
      moves = move_options(board)

      move = yield moves

      new_board = board.apply_move(move, as_player)
      recalculate_q(board, move, new_board, as_player)
      new_board
    end

    private def exploring?
      rand(100) < @explore_percent
    end

    private def recalculate_q(board, move, new_board, player)
      new_q = (1.0 - @learning_rate) * qsa_get_for_board(board, move, player) +
              @learning_rate * (reward(new_board, player) + @discount * value(new_board, player))
      qsa_set_for_board(board, move, player, new_q)
    end

    private def total_qsa_get_for_board(board, move, player) : Float32
      state = state_from_board(board)

      # TODO: This may be mistaken. Either "I" move or "they" do,
      #       so it doesn't make sense to combine "I" and "they" values.
      # generalise to N players, move to QSA then write specs.
      # Maybe the answer is: If "I" have qsa values, take the max of those.
      #           otherwise: If "they" gave qsa value take the min (or max) of -ve of those
      qsa.get(state, move, player) - qsa.get(state, move, other_player(player))
    end

    private def qsa_get_for_board(board, move, player)
      state = state_from_board(board)
      qsa.get(state, move, player)
    end

    private def qsa_set_for_board(board, move, player, new_q)
      state = state_from_board(board)
      qsa.set(state, move, player, new_q)
    end

    private def state_from_board(board)
      board.to_state
    end

    private def reward(board, player)
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

    private def value(board, player)
      qsa_get_for_options = board.move_options.map{ |move| total_qsa_get_for_board(board, move, player) }
      if qsa_get_for_options.empty?
        0.0
      else
        qsa_get_for_options.max
      end
    end

    private def other_player(player)
      Board.other_player(player) # player number is either 1 or 2
    end

  end
end
