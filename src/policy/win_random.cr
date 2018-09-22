require "../board"
require "./win_now_block_trap"

module Policy
  class WinRandom < Base
    # class << self

      def self.play(board, player)
        random_win_policy.play(board, player)
      end

      # private

      private def self.random_win_policy
        [
          WinNowBlockTrap,
          WinNowBlockTrap,
          WinNowBlockTrap,
          WinNowBlockTrap,
          WinNowBlockNaiveLine,
          WinNowBlockNaiveLine,
          WinNowBlockNaiveLine,
          WinNowBlock,
          WinNowBlock,
          WinNow
        ].sample
      end
    # end

  end
end
