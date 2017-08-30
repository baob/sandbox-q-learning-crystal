require 'board'

class Game

  def initialize(player_1_policy, player_2_policy, trace: true)
    @players = []
    @players[0] = {
      policy: player_1_policy,
      number: 1
    }
    @players[1] = {
      policy: player_2_policy,
      number: 2
    }
    @trace = trace
  end

  def play
    @board ||= Board.new
    move = 0
    loop do
      player_index = move % 2
      player = @players[player_index]
      puts "\nplayer making a move #{player}" if @trace
      @board = player[:policy].play(@board, player[:number])
      puts @board.to_s if @trace
      break if @board.game_over?
      move += 1
    end
    if w = @board.winner
      player = @players.select { |p| p[:number] == w }.first
      puts "\n\nplayer #{w} won, #{player}" if @board.is_win_for?(player[:number]) if @trace
      return player
    else
      puts "\n\n drawn" if @trace
      return
    end
  end

end
