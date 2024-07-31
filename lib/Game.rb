class Game
  attr_accessor :player1, :player2

  def initialize
    @player1 = { name: nil, token: nil }
    @player2 = { name: nil, token: nil }
    @available_tokens = ["\u232C", "\u25A9"]
  end

  def play_game
    create_players
  end

  def create_players
    request_name
  end

  def request_name
    if player1[:name].nil?
      puts "Please enter name of player 1:"
    else
      puts "Please enter name of player 2:"
    end

    player_name = gets.chomp

    player1[:name].nil? ? player1[:name] = player_name : player2[:name] = player_name
  end

  private
end