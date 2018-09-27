require "./policy/base"
class Player

  getter :policy, :token
  property :number

  @token : String
  @number : Int32
  @policy : Policy::Base

  def initialize(policy, token, number)
    @token  = token
    @number = number
    @policy = policy
  end

  def inspect
    "<Player:0x#{object_id.to_s(16)}"\
      " @token=\"#{@token}\""\
      " @number=\"#{@number}\""\
      " @policy.class=\"#{@policy.class}\""\
      ">"
  end


end
