module PlayerMove
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
end
