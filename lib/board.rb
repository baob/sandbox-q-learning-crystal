class Board

  NUMBER_OF_CELLS_PER_ROW = 3
  NUMBER_OF_CELLS_IN_BOARD = NUMBER_OF_CELLS_PER_ROW ** 2
  ENCODED_STATE_RADIX = 3
  CELL_INDEXES = 0..(NUMBER_OF_CELLS_IN_BOARD - 1)
  EMPTY_CELL = 0
  PLAYERS = [1,2]

  class << self

    # state is a transformation of each of the boards cells to digits in a base-3 number
    def from_state(state)
      board_moves = NUMBER_OF_CELLS_IN_BOARD.times.each_with_object([state]) do |n, x|
        q, r = x.pop.divmod(ENCODED_STATE_RADIX) ; x.push(q) ; x.unshift(r)
      end[CELL_INDEXES]

      new(board_moves)
    end

    def other_player(player)
      PLAYERS.reduce(&:+) - player
    end
  end

  def initialize(board = nil)
    @board = board || empty_board
  end

  def to_a
    @board
  end

  def move_options
    @board.each_with_index.select { |cell, index| cell == EMPTY_CELL }.map(&:last)
  end

  def ==(other)
    self.to_state == other.to_state
  end

  # Player here is a number, 1 or # 2 indicating 1st or 2nd
  #
  def apply_move(move, as_player)
    raise RuntimeError if @board[move] != EMPTY_CELL
    raise ArgumentError unless CELL_INDEXES.to_a.include?(move)
    raise ArgumentError unless PLAYERS.include?(as_player)

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
    PLAYERS.each { |player| return player if is_win_for?(player) }
    return
  end

  def game_over?
    winner || no_moves_left?
  end

  def no_moves_left?
    move_options.size == 0
  end

  def to_s(tokens = PLAYERS.map(&:to_s).reduce(&:+))
    count = 0
    @board.each_with_object('') do |cell, string|
      if cell == EMPTY_CELL
        string << '.'
      else
        string << tokens[cell-1]
      end
      count += 1
      string << "\n" if count % NUMBER_OF_CELLS_PER_ROW == 0
    end
  end

  # state is a transformation of each of the boards cells to digits in a base-3 number
  def to_state
    @board.reduce(0) do |memo, digit|
      memo = ENCODED_STATE_RADIX * memo + digit
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
    NUMBER_OF_CELLS_IN_BOARD.times.map { EMPTY_CELL }
  end
end
