class PlayingCard
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
	   "#{@rank} of #{@suit}"
	end

  def rank
    @rank
  end

  def suit
    @suit
  end

end
