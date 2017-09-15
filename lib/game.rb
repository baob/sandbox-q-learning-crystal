require 'board'
require 'player'

policy_files = File.expand_path('policy/**/*.rb', __dir__)
Dir[policy_files].each(&method(:require))

class Game

  def initialize(player_a_policy, player_b_policy, trace: true)

    @players = []

    @players << Player.new(
      policy: player_a_policy,
      token:  'X'
    )
    @players << Player.new(
      policy: player_b_policy,
      token:  'O'
    )

    @trace = trace
  end

  def other_player(player)
    @players.detect { |other_player| other_player != player }
  end

  def play
    @board ||= Board.new
    player = @players.sample
    player.number = 1
    other_player(player).number = 2
    tokens = player.token + other_player(player).token

    loop do
      puts "\nplayer making a move #{player.inspect}" if @trace
      @board = player.policy.play(@board, player.number)
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
