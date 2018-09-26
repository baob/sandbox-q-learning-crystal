require "../board"
require "./base"

module Policy
  class Random < Base
    # class << self

    def self.chosen_move(_board, _player, moves)
      random_move(moves)
    end

    # private

    private def self.random_move(moves)
      moves.sample
    end

    # end

  end
end
