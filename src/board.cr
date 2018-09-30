class Board

  NUMBER_OF_CELLS_PER_ROW = 3
  NUMBER_OF_CELLS_IN_BOARD = NUMBER_OF_CELLS_PER_ROW**2
  ENCODED_STATE_RADIX = 3
  CELL_INDEXES = 0..(NUMBER_OF_CELLS_IN_BOARD - 1)
  EMPTY_CELL = 0
  PLAYERS = [1, 2]

  @board : Array(Int32)

  # class << self
  

  # state is a transformation of each of the boards cells to digits in a base-3 number
  def self.from_state(state)
    board_moves = NUMBER_OF_CELLS_IN_BOARD.times.each_with_object([state]) do |_n, x|
      q, r = x.pop.divmod(ENCODED_STATE_RADIX) ; x.push(q) ; x.unshift(r)
    end[CELL_INDEXES]

    new(board_moves)
  end

  def self.other_player(player)
    PLAYERS.reduce{|memo, value| memo + value} - player
  end
  # end

  def initialize(board : ::Nil | Array(Int32)  = nil )
    @board = board || empty_board
  end

  def to_a
    @board
  end

  def move_options
    @board.each_with_index.select { |(cell, _index)| cell == EMPTY_CELL }.map { |(cell, index)| index }.to_a
  end

  def ==(other)
    to_state == other.to_state
  end

  # Player here is a number, 1 or # 2 indicating 1st or 2nd
  #
  def apply_move(move, as_player)
    raise ArgumentError.new if @board[move] != EMPTY_CELL
    raise ArgumentError.new unless CELL_INDEXES.to_a.includes?(move)
    raise ArgumentError.new unless PLAYERS.includes?(as_player)

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
    nil
  end

  def game_over?
    winner || no_moves_left?
  end

  def no_moves_left?
    move_options.size == 0
  end

  def to_s(tokens = PLAYERS.map{ |p| p.to_s }.reduce{ |p1, p2| p1 + p2 })
    count = 0
      String.build do |str|
      @board.each_with_object(str) do |cell, string|
        if cell == EMPTY_CELL
          string << '.'
        else
          string << tokens[cell - 1].to_s
        end
        count += 1
        string << "\n" if count % NUMBER_OF_CELLS_PER_ROW == 0
      end
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

  # private

  private def empty_board
    # NUMBER_OF_CELLS_IN_BOARD.times.map { EMPTY_CELL }

    [ EMPTY_CELL ] * NUMBER_OF_CELLS_IN_BOARD
  end
end
