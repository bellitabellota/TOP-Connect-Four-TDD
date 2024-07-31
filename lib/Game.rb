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
    
  end

  private
end