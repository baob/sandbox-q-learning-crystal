require "./policy/base"
class Player

  property :policy, :token, :number

  @token : String
  @number : Int32
  @policy : Policy::Base

  def initialize(policy, token, number)
    @token  = token
    @number = number
    @policy = policy
  end

end
