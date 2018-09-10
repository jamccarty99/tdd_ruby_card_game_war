require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_client'

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
      expect(@server.games.count).to be 0
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

    it 'to start a game, a message is sent to both clients, and its reception is confirmed by them' do
      @server.create_game_if_possible
      expect(@server.games.count).to be 1
      expect(@clients[0].capture_output).to match(/Ready to begin a game of WAR?/)
      expect(@clients[1].capture_output).to match(/Ready to begin a game of WAR?/)
      @clients[0].provide_input("ready")
      @clients[1].provide_input("ready")
      expect(@server.capture_output).to match(/ready/)
    end

    it 'runs a game of war' do
      game = WarGame.new
      @server.create_game_if_possible
      @server.run_game(game)
    end

    it 'creates a new thread for every game and keeps them in an array' do
      game = WarGame.new
      @server.create_game_if_possible
      @server.run_game(game)
      expect(@server.run_game(game).thread.count).to eq 1
    end
  end

  describe 'WarClient' do

    let(:client1) { WarClient.new(socket1, "Master") }
    let(:client2) { WarClient.new(socket2, "Apprentice") }
    let(:socket1) { @server.accept_new_client("Master") }
    let(:socket2) { @server.accept_new_client("Apprentice") }
    before(:each) do
      @server = WarSocketServer.new
      @server.start
      socket1
      @server.create_game_if_possible
      expect(@server.games.count).to be 0
      socket2
    end

    after(:each) do
      @server.stop
    end

    it 'Should contain a client' do
      expect(client1.client).to eq socket1
    end
    it 'Should contain a name' do
      expect(client1.name).to eq "Master"
    end

    describe 'provide_input' do
      it 'Should put a text message to the server' do
        expect(client1.provide_input("hello world"))
      end
    end
  end
