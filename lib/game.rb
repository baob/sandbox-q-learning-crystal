require 'board'
require 'player'

policy_files = File.expand_path('policy/**/*.rb', __dir__)
Dir[policy_files].each(&method(:require))

class Game

  def initialize(player_a_policy, player_b_policy, trace: true)

    @players = []

    @players << Player.new(
      policy: player_a_policy,
      number: [1, 2].sample,
      token:  'X'
    )
    @players << Player.new(
      policy: player_b_policy,
      number: 3 - @players[0].number,
      token:  'O'
    )

    @trace = trace
  end

  def other_player(player)
    @players.detect { |other_player| other_player != player }
  end

  def play_best
    play(best: true)
  end

  def play(best: false)
    @board ||= Board.new
    player = @players.detect { |p| p.number == 1 }
    tokens = player.token + other_player(player).token
    play_method = best ? :play_best : :play

    loop do
      puts "\nplayer making a move #{player.inspect}" if @trace
      @board = player.policy.send(play_method, @board, player.number)
      puts @board.to_s(tokens) if @trace
      break if @board.game_over?
      player = other_player(player)
    end

    if w = @board.winner
      player = @players.detect { |p| p.number == w }
      puts "\n\nplayer #{w} won, #{player}" if @board.is_win_for?(player.number) if @trace
      return player
    else
      puts "\n\n drawn" if @trace
      return
    end
  end

end
