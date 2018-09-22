class Player

  attr_reader :policy, :token, :number

  def initialize(policy, token, number)
    @token  = token
    @number = number
    @policy = policy
  end

end
