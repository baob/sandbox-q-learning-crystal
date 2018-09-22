require "board"
require "policy/win_now_block_trap"

module Policy
  class WinRandom < Base
    class << self

      def play(board, player)
        random_win_policy.play(board, player)
      end

      private

      def random_win_policy
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
    end

  end
end
