require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end
end
  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
  describe WarSocketServer do
    before(:each) do
      @clients = []
      @server = WarSocketServer.new
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player 1")
      @server.create_game_if_possible
      client2 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player 2")
    end

    after(:each) do
      @server.stop
      @clients.each do |client|
        client.close
      end
    end

    describe 'handInfo' do
      it 'Should send players a message with their card count' do
        game = WarGame.new
        game.start
        @clients.map{ |client| client.capture_output}
        @server.create_game_if_possible
        testClientOutput(/cards left/)
      end
    end

    describe 'gameMessages' do
      it 'Should send players a message with text passed in' do
        game = WarGame.new
        game.start
        @clients.map{ |client| client.capture_output}
        @server.create_game_if_possible
        testClientOutput(/Ready to begin/)
      end
    end

    xit 'creates a new thread for every game and keeps them in an array' do
      game = WarGame.new
      @server.create_game_if_possible
      @server.run_game(game)
      expect(@server.run_game(game).thread.count).to eq 1
    end
  end

  def testClientOutput(expectedOutput)
    expect(@clients[0].capture_output).to match (expectedOutput)
    expect(@clients[1].capture_output).to match (expectedOutput)
  end
