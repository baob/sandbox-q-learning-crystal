class Player

  attr_reader :policy, :token
  attr_accessor :other_player, :number

  def initialize(policy:, token:)
    @policy = policy
    @token  = String(token)
  end

end
