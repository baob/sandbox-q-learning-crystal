class Board
  def initialize(board = nil)
    @board = board || empty_board
  end

  def to_a
    @board
  end

  def move_options
    @board.each_with_index.select { |cell, index| cell == 0 }.map(&:last)
  end

  def apply_move(move, as_player)
    raise RuntimeError if @board[move] != 0
    raise ArgumentError unless (0..8).to_a.include?(move)
    raise ArgumentError unless [1, 2].include?(as_player)
    new_board = @board.dup
    new_board[move] = as_player
    self.class.new(new_board)
  end

  def is_win_for?(player)
    WINS.map do |row|
      @board[row[0]] == player &&
      @board[row[1]] == player &&
      @board[row[2]] == player
    end.any?
  end

  def game_over?
    is_win_for?(1) || is_win_for?(2) || move_options.size == 0
  end

  def to_s(tokens = "12")
    count = 0
    @board.each_with_object('') do |cell, string|
      if cell == 0
        string << '.'
      else
        string << tokens[cell-1]
      end
      count += 1
      string << "\n" if count % 3 == 0
    end
  end

  WINS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  private

  def empty_board
    9.times.map { 0 }
  end
end