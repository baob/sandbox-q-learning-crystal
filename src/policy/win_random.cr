require "../board"
require "./win_now_block_trap"

module Policy
  class WinRandom < Base

    def self.policy
      new
    end

    # class << self

      def play(board, player)
        random_win_policy.play(board, player)
      end

      # private

      private def random_win_policy
        [
          WinNowBlockTrap.policy,
          WinNowBlockTrap.policy,
          WinNowBlockTrap.policy,
          WinNowBlockTrap.policy,
          WinNowBlockNaiveLine.policy,
          WinNowBlockNaiveLine.policy,
          WinNowBlockNaiveLine.policy,
          WinNowBlock.policy,
          WinNowBlock.policy,
          WinNow.policy
        ].sample
      end
    # end

  end
end
