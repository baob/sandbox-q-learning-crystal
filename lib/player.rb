class Player

  attr_reader :policy, :token
  attr_accessor :number

  def initialize(policy:, token:)
    @token  = String(token)
    @policy = policy
  end

end
