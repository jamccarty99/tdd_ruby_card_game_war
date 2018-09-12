class WarClient
  attr_accessor   :connection, :ready
  attr_reader   :name

  def initialize(connection, player_name)
    @connection = connection
    @name = player_name
    @ready = false
  end

end
