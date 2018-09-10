class WarClient
  attr_reader   :client
  attr_reader   :name

  def initialize(client, player_name)
    @client = client
    @name = player_name
  end

  # def provide_input(text)
  #   @socket.puts(text)
  # end
  #
  # def capture_output(delay=0.1)
  #   sleep(delay)
  #   @output = @socket.read_nonblock(1000) # not gets which blocks
  # rescue IO::WaitReadable
  #   @output = ""
  # end

  def ready?
  end

end
