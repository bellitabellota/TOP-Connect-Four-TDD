class Game
  attr_accessor :player1, :player2
  attr_reader :available_tokens

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
    assign_token
  end

  def assign_token
    if player1[:token].nil?
      puts "Time to choose your token. Press '0' for \u232C or '1' for '\u25A9'. Please enter your choice:"
      input = player_input_token

      input == 0 ? player1[:token] = available_tokens.shift : player1[:token] = available_tokens.pop

      puts "#{player1[:name]} chose #{player1[:token]}."
    else
      player2[:token] = available_tokens.pop
      puts "#{player2[:name]} your token is #{player2[:token]}."
    end
  end

  def player_input_token
    loop do
      input = gets.chomp

      return input.to_i if ["0", "1"].include?(input)

      puts "Invalid input. Try again:"
    end
  end

  def request_name
    if player1[:name].nil?
      puts "Please enter name of player 1:"
      player_name = gets.chomp
      player1[:name] = player_name
    else
      puts "Please enter name of player 2:"
      player_name = gets.chomp
      player2[:name] = player_name
    end
  end

  private
end