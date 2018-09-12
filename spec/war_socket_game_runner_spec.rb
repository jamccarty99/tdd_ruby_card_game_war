require 'socket'
require_relative 'war_socket_server_spec'
require_relative '../lib/war_socket_server'
require_relative '../lib/war_socket_game_runner'

describe 'WarSocketGameRunner' do
  before(:each) do
    @clients = []
    @serverClients = []
    @server = WarSocketServer.new
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @serverClients.push(@server.accept_new_client("Player 1"))
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @serverClients.push(@server.accept_new_client("Player 2"))
    @clients.map{ |client| client.capture_output}
    @game = @server.create_game_if_possible
    @runner = WarSocketGameRunner.new(@game, @serverClients)
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  describe 'listen_to_clients' do
    it "Should receive a message asking if the players are ready to play" do
      @clients[0].capture_output.strip
      @runner.start
      expect(@clients[0].capture_output.strip).to match /Ready to begin/
    end

    it "Should set a variable to true if both players are ready" do
      @clients.map{ |client| client.provide_input("ready")}
      sleep(0.1)
      @runner.listen_to_clients
      expect(@runner.ready?).to eq true
    end
  end

  describe 'play_round' do
    it 'Should not play a round if both players are not ready'do
      @clients.map{ |client| client.capture_output}
      @clients[0].provide_input("ready")
      test_setup
      expect(@clients[0].capture_output).not_to match /won the/
      expect(@clients[1].capture_output).not_to match /won the/
    end

    it 'Should play a round if both players are ready and send the results to both players'do
      @clients.map{ |client| client.capture_output}
      @clients.map{ |client| client.provide_input("ready")}
      test_setup
      testClientOutput(/won the/)
    end
  end

end

def test_setup
  @runner.listen_to_clients
  @runner.play_round
end
