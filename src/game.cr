require "./board"
require "./player"
require "./policy/*"

# policy_files = File.expand_path("policy/**/*.rb", __dir__)
# Dir[policy_files].each(&method(:require))

class Game

  def initialize(player_a_policy, player_b_policy, trace = true)

    @players = [] of Player

    @players << Player.new(
      policy: player_a_policy,
      number: Board::PLAYERS.sample, # player number is 1 or 2
      token:  "X"
    )
    @players << Player.new(
      policy: player_b_policy,
      number: Board.other_player(@players[0].number), # player number is 1 or 2
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
    player : Player = @players.find { |p| p.number == 1 }
    raise Exception.new if player.nil?
    the_other : Player = other_player(player)
    raise Exception.new if the_other.nil?
    tokens = player.token + the_other.token
    play_method = best ? :play_best : :play

    loop do
      puts "\nplayer making a move #{player.inspect}" if @trace
      @board = if best
        player.policy.play_best(@board, player.number)
      else
        player.policy.play(@board, player.number)
      end
      puts @board.to_s(tokens) if @trace
      break if @board.game_over?
      player = other_player(player)
    end

    if w = @board.winner
      player = @players.find { |p| p.number == w }
      puts "\n\nplayer #{w} won, #{player}" if @trace && @board.is_win_for?(player.number)
      return player
    else
      puts "\n\n drawn" if @trace
      return
    end
  end

end
