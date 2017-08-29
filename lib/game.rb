require 'board'

class Game

  def initialize(player_1_policy, player_2_policy)
    @players = []
    @players[0] = {
      policy: player_1_policy,
      number: 1
    }
    @players[1] = {
      policy: player_2_policy,
      number: 2
    }
  end

  def play
    @board ||= Board.new
    move = 0
    loop do
      player_index = move % 2
      player = @players[player_index]
      puts
      puts "player making a move #{player}"
      @board = player[:policy].play(@board, player[:number])
      puts
      puts @board.to_s
      break if @board.game_over?
      move += 1
    end
    @players.each do |player|
      puts "\n\nplayer #{player[:number]} won" if @board.is_win_for?(player[:number])
    end
  end

end
