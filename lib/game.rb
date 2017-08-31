require 'board'
require 'player'

class Game

  def initialize(player_1_policy, player_2_policy, trace: true)

    @players = []

    @players << Player.new(
      policy: player_1_policy,
      token:  'X'
    )

    @players << Player.new(
      policy: player_2_policy,
      token:  'O'
    )
    @players[0].other_player = @players[1]
    @players[1].other_player = @players[0]

    @trace = trace
  end

  def play
    @board ||= Board.new
    move = 0
    player = @players.sample
    player.number = 1
    player.other_player.number = 2
    tokens = player.token + player.other_player.token
    loop do
      puts "\nplayer making a move #{player}" if @trace
      @board = player.policy.play(@board, player.number)
      puts @board.to_s(tokens) if @trace
      break if @board.game_over?
      move += 1
      player = player.other_player
    end
    if w = @board.winner
      player = @players.select { |p| p.number == w }.first
      puts "\n\nplayer #{w} won, #{player}" if @board.is_win_for?(player.number) if @trace
      return player
    else
      puts "\n\n drawn" if @trace
      return
    end
  end

end
