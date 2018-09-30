require "../board"
require "./base"

module Policy
  class Random < Base
    def self.policy
      new
    end
        # class << self

    def chosen_move(_board, _player, moves)
      random_move(moves)
    end

    # private

    private def random_move(moves)
      moves.sample
    end

    # end

  end
end
