require "./board"
require "./player"
require "./policy/*"

# policy_files = File.expand_path("policy/**/*.rb", __dir__)
# Dir[policy_files].each(&method(:require))

class Game

  def initialize(player_a_policy : Policy::Base, player_b_policy : Policy::Base, trace = true)

    @players = [] of Player

    @players << Player.new(
      policy: player_a_policy,
      number: 1, # player number is 1 or 2
      token:  "X"
    )
    @players << Player.new(
      policy: player_b_policy,
      number: 2, # player number is 1 or 2
      token:  "O"
    )

    @trace = trace

    @board = Board.new
  end

  def other_player(player)
    @players.find { |other_player| other_player != player }
  end

  def play_best
    play(best: true)
  end

  def play(best = false)

    if [true, false].sample
      playloop(@players[0], @players[1], best)
    else
      playloop(@players[1], @players[0], best)
    end

  end

  private def playloop(player : Player, the_other : Player, best)
    tokens = player.token + the_other.token
    player.number = 1
    the_other.number = 2
    
    loop do
      puts "\nplayer making a move #{player.inspect}" if @trace
      @board = if best
        player.policy.play_best(@board, player.number)
      else
        player.policy.play(@board, player.number)
      end
      puts @board.to_s(tokens) if @trace
      break if @board.game_over?
      player_next = the_other
      the_other_next = player
      player = player_next
      the_other = the_other_next
    end

    if w = @board.winner
      player = @players[w-1]
      puts "\n\nplayer #{w} won, #{player}" if @trace && @board.is_win_for?(player.number)
      return player
    else
      puts "\n\n drawn" if @trace
      return
    end
  end
end
