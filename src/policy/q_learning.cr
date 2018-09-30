require "../board"
require "./base"
require "../qsa"

module Policy
  class QLearning < Base

    def self.policy(trace = false)
      new(trace: trace)
    end
    

    property :explore_percent, :learning_rate, :discount, :trace

    def initialize(trace : Bool = trace)

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
      @trace = trace
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
      puts "\nExploit move:" if @trace
      if moves.size == 1
        move = moves.first
      else 
        exploiting_moves = choose_exploiting_moves(board, player, moves)
        move = exploiting_moves.sample
      end
      if @trace
        puts "possible moves #{moves}"
        puts "exploiting moves #{exploiting_moves}"
        puts "Exploiting move #{move}"
      end
      move
    end

    def choose_exploiting_moves(board, player, moves)
      puts "\nExploiting moves:" if @trace
      return [moves.first] if moves.size == 1
      if @trace
        puts "START ordering by qsa get (to choose Exploit move)"
      end
      qsa_values_by_move = moves.reduce({} of Int32 => Float32) do |memo, move|
        memo[move] = total_qsa_get_for_board(board, move, player, trace: false)
        memo
      end
      puts "qsa_values_by_move: #{qsa_values_by_move}" if @trace
      moves_ordered_by_total_qsa_get = moves.sort { |move1, move2| qsa_values_by_move[move1] <=> qsa_values_by_move[move2] }
      move = moves_ordered_by_total_qsa_get.last
      qsa = qsa_values_by_move[move]
      exploiting_moves = moves.select { |m| (qsa_values_by_move[m] - qsa).abs < 0.000001 }
      if @trace
        puts "possible moves #{moves}"
        puts "moves_ordered_by_total_qsa_get #{moves_ordered_by_total_qsa_get}"
        puts "END ordering by qsa get (to choose Exploit move)"
        puts "Exploiting moves #{exploiting_moves}"
      end
      exploiting_moves
    end

    def choose_exploring_move(board, player, moves)
      if @trace
        puts "\nExplore move:" 
        puts "possible moves #{moves}"
      end

      if moves.size == 1
        move = moves.first
      else
        exploring_moves = moves - choose_exploiting_moves(board, player, moves)
        if exploring_moves.empty?
          move = moves.sample
        else
          if exploring_moves.size == 1
            move = exploring_moves.first
          else
            move = exploring_moves.sample
          end
        end
        if @trace
          puts "exploring moves #{exploring_moves}"
        end
      end

      if @trace
        puts "Exploring move #{move}"
      end
    move
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
      if qsa.qsa[0]? 
        puts "Corners:"
        puts "qsa.qsa[0][0] #{qsa.qsa[0][0]}" if qsa.qsa[0][0]?
        puts "qsa.qsa[0][2] #{qsa.qsa[0][2]}" if qsa.qsa[0][2]?
        puts "qsa.qsa[0][6] #{qsa.qsa[0][6]}" if qsa.qsa[0][6]?
        puts "qsa.qsa[0][8] #{qsa.qsa[0][8]}" if qsa.qsa[0][8]?
        puts "Edges:"
        puts "qsa.qsa[0][1] #{qsa.qsa[0][1]}" if qsa.qsa[0][1]?
        puts "qsa.qsa[0][3] #{qsa.qsa[0][3]}" if qsa.qsa[0][3]?
        puts "qsa.qsa[0][5] #{qsa.qsa[0][5]}" if qsa.qsa[0][5]?
        puts "qsa.qsa[0][7] #{qsa.qsa[0][7]}" if qsa.qsa[0][7]?
        puts "Centre:"
        puts "qsa.qsa[0][4] #{qsa.qsa[0][4]}" if qsa.qsa[0][4]?
      else
        puts "No qsa.qsa[0]?..."
        puts "qsa.qsa.keys #{qsa.qsa.keys}"
      end
     puts "\n"

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

    # Reference:  https://en.wikipedia.org/wiki/Q-learning#Algorithm

    private def recalculate_q(board, move, new_board, player)
      old_q = qsa_get_for_board(board, move, player)
      new_reward = reward(new_board, player)
      if @trace
        puts "\n"
        puts "old_q: #{old_q} (qsa_get_for_board(board, move: #{move}, player: #{player}))"
        puts "new_reward: #{new_reward} (reward(new_board, player: #{player}))"
      end

      if final_state?(new_board, player)
        new_q = new_reward
        puts "new_q: #{new_q} (direct assign new_reward because final state)" if @trace
      else
        future_value = estimate_optimal_future_value(new_board, player)

        new_q = (1.0 - @learning_rate) * old_q +
                @learning_rate * (new_reward + @discount * future_value)
        if @trace
          puts "future_value: #{future_value} (estimate_optimal_future_value(new_board, player: #{player}))"
          puts "new_q: #{new_q} (balance old and new with @discount #{@discount} and @learning_rate #{@learning_rate})"
        end
      end
      qsa_set_for_board(board, move, player, new_q)
      if @trace
        plays_so_far = board.to_a.count{ |p| p != 0 }
        puts "plays so far #{plays_so_far}"
        puts "board_as_array(board) #{board_as_array(board)}"
        puts "move #{move}"
        puts "player #{player}"
        puts "\n"
      end
    end

    private def total_qsa_get_for_board(board, move, player, trace = @trace) : Float32
      state = state_from_board(board)

      # TODO: This may be mistaken. Either "I" move or "they" do,
      #       so it doesn't make sense to combine "I" and "they" values.
      # generalise to N players, move to QSA then write specs.
      # Maybe the answer is: If "I" have qsa values, take the max of those.
      #           otherwise: If "they" gave qsa value take the min (or max) of -ve of those
      value_to_player       = qsa.get(state, move, player)
      value_to_other_player = qsa.get(state, move, other_player(player))
      total = value_to_player - value_to_other_player
      if trace
        puts "\ntotal_qsa_get for possible move #{move} on board_state #{state}"
        puts "qsa value_to player #{player}: #{value_to_player}"
        puts "qsa value_to player #{other_player(player)}: #{value_to_other_player}"
        puts "net value to player #{player}: #{total}"
      end
      total
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

    private def board_as_array(board)
      board.to_a
    end

    private def reward(board, player)
      if board.is_win_for?(player)
        1.0
      elsif board.next_time_is_win_for?(other_player(player))
        -1.0
      elsif board.next_time_could_be_win_for?(other_player(player))
        -1.0
      elsif board.game_over?
        0.75
      elsif board.next_time_is_game_over?
        0.75
      else
        0.5
      end
    end

    private def final_state?(board, player) : Bool
      if @trace
        puts "board.is_win_for?(player: #{player}) #{board.is_win_for?(player)}"
        puts "board.game_over? #{board.game_over?}"
      end
      return true if board.is_win_for?(player) 
      return true if board.game_over?
      false
    end

    private def estimate_optimal_future_value(board, player)
      puts "\nSTART determining value of board to player #{player}" if @trace
      qsa_get_for_options = board.move_options.map{ |move| 0.0 - total_qsa_get_for_board(board, move, player) }
      r = if qsa_get_for_options.empty?
        0.0
      else
        qsa_get_for_options.min
      end
      puts "value of board at state #{board_as_array(board)} to player #{player} is #{r}" if @trace
      puts "END determining value of board to player #{player}" if @trace
      r
    end

    private def other_player(player)
      Board.other_player(player) # player number is either 1 or 2
    end

  end
end
