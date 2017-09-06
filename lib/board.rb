class Board
  class << self
    def from_state(state)
      board_moves = 9.times.each_with_object([state]) { |n, x| q, r = x.pop.divmod(3) ; x.push(q) ; x.unshift(r) }[0..8]
      new(board_moves)
    end
  end

  def initialize(board = nil)
    @board = board || empty_board
  end

  def to_a
    @board
  end

  def move_options
    @board.each_with_index.select { |cell, index| cell == 0 }.map(&:last)
  end

  # Player here is a number, 1 or # 2 indicating 1st or 2nd
  #
  def apply_move(move, as_player)
    raise RuntimeError if @board[move] != 0
    raise ArgumentError unless (0..8).to_a.include?(move)
    raise ArgumentError unless [1, 2].include?(as_player)
    new_board = @board.dup
    new_board[move] = as_player
    self.class.new(new_board)
  end

  def is_win_for?(player)
    # puts "checking for win by #{player}"
    WINS.map do |row|
      # puts "checking for win on #{row.inspect} by #{player}"
      @board[row[0]] == player &&
      @board[row[1]] == player &&
      @board[row[2]] == player
    end.any?
  end

  def next_time_is_win_for?(player)
    next_time_is_game_over? && next_time_could_be_win_for?(player)
  end

  def next_time_could_be_win_for?(player)
    move_options.map do |move|
      apply_move(move, player).is_win_for?(player)
    end.any?
  end

  def next_time_is_game_over?
    move_options.size == 1
  end

  def winner
    return 1 if is_win_for?(1)
    return 2 if is_win_for?(2)
  end

  def game_over?
    winner || no_moves_left?
  end

  def no_moves_left?
    move_options.size == 0
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

  def to_state
    @board.reduce(0) do |memo, digit|
      memo = 3 * memo + digit
      memo
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
