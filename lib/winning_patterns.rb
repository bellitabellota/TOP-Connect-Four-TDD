module WinningPattern
  def vertical_pattern?
    index1 = last_token_position[0]
    index2 = last_token_position[1]

    if index1 >= 3
      3.times do
        index1 -= 1
        return false if board[index1][index2] != current_player[:token]
      end
      true
    else
      false
    end
  end

  def horizontal_pattern?
    index1 = last_token_position[0]
    token = current_player[:token]

    row = board[index1]

    case row
    in ["#{token}", "#{token}", "#{token}", "#{token}", _, _, _] then true
    in [_, "#{token}", "#{token}", "#{token}", "#{token}", _, _] then true
    in [_, _, "#{token}", "#{token}", "#{token}", "#{token}", _] then true
    in [_, _, _, "#{token}", "#{token}", "#{token}", "#{token}"] then true
    else false
    end
  end

  def diagonal_pattern?
    from_lower_left_to_upper_right? || from_lower_right_to_upper_left?
  end

  def from_lower_right_to_upper_left?
    index1 = last_token_position[0]
    index2 = last_token_position[1]

    if index1 >= 3
      3.times do
        index1 -= 1
        index2 += 1
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

        return false if index2.negative?
        return false if board[index1][index2] != current_player[:token]
      end
      true
    else
      false
    end
  end
end
