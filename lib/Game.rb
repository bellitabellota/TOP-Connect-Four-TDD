class Game
  attr_accessor :player1, :player2, :board, :current_player, :last_token_position
  attr_reader :available_tokens

  def initialize
    @player1 = { name: nil, token: nil }
    @player2 = { name: nil, token: nil }
    @available_tokens = ["\u232C", "\u25A9"]
    @board = Array.new(6) { Array.new(7, " ") }
    @current_player = player1
    @last_token_position = [nil, nil]
  end

  def play_game
    create_players
    visualizing_board
    loop do
      make_player_move(current_player)
      visualizing_board
      return puts "#{current_player[:name]} wins the game!" if win?
      return puts "Tie. Board is full. Nobody won." if board_is_full?
      update_current_player
    end
  end

  def win?
    diagonal_pattern?
    
  end

  def diagonal_pattern?
    from_lower_left_to_upper_right?
  end

  def from_lower_right_to_upper_left?
    index1 = last_token_position[0]
    index2 = last_token_position[1]

    if index1 >= 3
      3.times do
        index1 -= 1
        index2 += 1

        return false if index1.negative? || index2.negative?
        return false if board[index1][index2] != current_player[:token]
      end
      true
    else
      false
    end
  end

  def from_lower_left_to_upper_right?
    index1 = last_token_position[0]
    index2 = last_token_position[1]

    if index1 >= 3
      3.times do
        index1 -= 1
        index2 -= 1

        return false if index1.negative? || index2.negative?
        return false if board[index1][index2] != current_player[:token]
      end
      true
    else
      false
    end
  end

  def board_is_full?
    flattened_board = board.flatten
    flattened_board.none?(" ")
  end

  def update_current_player
    if current_player == player1
      self.current_player = player2
    else
      self.current_player = player1
    end
  end

  def make_player_move(player)
    puts
    puts "#{player[:name]}, please make your move by entering the number of the column in which you want to place your token:"
    next_move = verified_move
    place_token(next_move)
  end

  def place_token(next_move)
    index_row = find_free_slot(next_move)
    update_free_slot_with_player_token(index_row, next_move)
  end

  def update_free_slot_with_player_token(index_row, next_move)
    board[index_row][next_move - 1] = current_player[:token]
    last_token_position[0] = index_row
    last_token_position[1] = next_move - 1
  end

  def find_free_slot(next_move)
    board.each_with_index { |array, index| break index if array[next_move - 1] == " " }
  end

  def verified_move
    loop do
      next_move = request_next_move

      return next_move if column_has_empty_slot?(next_move)

      puts "Column already complete. Please choose another column:"
    end
  end

  def column_has_empty_slot?(next_move)
    index_column = next_move - 1
    board.each { |array| return true if array[index_column] == " " }
    false
  end

  def request_next_move
    loop do
      input = gets.chomp

      return input.to_i if input.match?(/^\d+$/) && (1..7).include?(input.to_i)

      puts "Invalid input. Please enter a number between 1 and 7:"
    end
  end

  def create_players
    2.times do
      request_name
      assign_token
    end
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
    puts
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

  def visualizing_board
    puts
    puts "| #{board[5][0]} | #{board[5][1]} | #{board[5][2]} | #{board[5][3]} | #{board[5][4]} | #{board[5][5]} | #{board[5][6]} |"
    puts "| #{board[4][0]} | #{board[4][1]} | #{board[4][2]} | #{board[4][3]} | #{board[4][4]} | #{board[4][5]} | #{board[4][6]} |"
    puts "| #{board[3][0]} | #{board[3][1]} | #{board[3][2]} | #{board[3][3]} | #{board[3][4]} | #{board[3][5]} | #{board[3][6]} |"
    puts "| #{board[2][0]} | #{board[2][1]} | #{board[2][2]} | #{board[2][3]} | #{board[2][4]} | #{board[2][5]} | #{board[2][6]} |"
    puts "| #{board[1][0]} | #{board[1][1]} | #{board[1][2]} | #{board[1][3]} | #{board[1][4]} | #{board[1][5]} | #{board[1][6]} |"
    puts "| #{board[0][0]} | #{board[0][1]} | #{board[0][2]} | #{board[0][3]} | #{board[0][4]} | #{board[0][5]} | #{board[0][6]} |"
    puts " \u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E\u203E"
    puts "  1   2   3   4   5   6   7  "
  end

  private
end
