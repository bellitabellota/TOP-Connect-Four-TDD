require_relative "../lib/Game"

describe Game do
  subject(:game) { described_class.new }

  describe "#request_name" do
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return("Pete")
    end

    context "when no player name has been assigned yet" do
      it "assigns name to player 1" do
        game.request_name
        expect(game.player1[:name]).to eq("Pete")
      end

      it "asks for name of player 1" do
        expect(game).to receive(:puts).with("Please enter name of player 1:")
        game.request_name
      end
    end

    context "when player1 has name assigned" do
      it "assigns name to player 2" do
        game.request_name
        allow(game).to receive(:gets).and_return("Carl")
        game.request_name
        expect(game.player2[:name]).to eq("Carl")
      end

      it "asks for name of player 2" do
        game.request_name
        expect(game).to receive(:puts).with("Please enter name of player 2:")
        game.request_name
      end
    end
  end

  describe "#assign_token" do
    context "when player1 chooses first token (\u232C )" do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:player_input_token).and_return(0)
        game.assign_token
      end

      context "when no token has been assigned" do
        it "assigns chosen token to player 1" do
          expect(game.player1[:token]).to eq("\u232C")
        end

        it "removes chosen token from @available_tokens array" do
          expect(game.available_tokens).to eq(["\u25A9"])
        end
      end

      context "when a token was already chosen by player 1" do
        it "assigns remaining token to player 2" do
          game.assign_token
          expect(game.player2[:token]).to eq("\u25A9")
        end

        it "removes last remaining token from @available_tokens array" do
          game.assign_token
          expect(game.available_tokens).to eq([])
        end
      end
    end

    context "when player1 chooses second token (\u25A9 )" do
      before do
        allow(game).to receive(:puts)
        allow(game).to receive(:player_input_token).and_return(1)
        game.assign_token
      end

      context "when no token has been assigned" do
        it "assigns chosen token to player 1" do
          expect(game.player1[:token]).to eq("\u25A9")
        end

        it "removes chosen token from @available_tokens array" do
          expect(game.available_tokens).to eq(["\u232C"])
        end
      end

      context "when a token was already chosen by player 1" do
        it "assigns remaining token to player 2" do
          game.assign_token
          expect(game.player2[:token]).to eq("\u232C")
        end

        it "removes last remaining token from @available_tokens array" do
          game.assign_token
          expect(game.available_tokens).to eq([])
        end
      end
    end
  end

  describe "#player_input_token" do
    context "when input is 0" do
      it "returns 0" do
        allow(game).to receive(:gets).and_return("0\n")
        return_value = game.player_input_token
        expect(return_value).to eq(0)
      end
    end

    context "when input is 1" do
      it "returns 1" do
        allow(game).to receive(:gets).and_return("1\n")
        return_value = game.player_input_token
        expect(return_value).to eq(1)
      end
    end

    context "when it receives twice an invalid input and then a valid input (0 or 1)" do
      it "prints twice the invalid message input" do
        allow(game).to receive(:puts).with("Invalid input. Try again:")
        input_symbol = "+\n"
        input_letter = "d\n"
        valid_input = "1\n"
        allow(game).to receive(:gets).and_return(input_symbol, input_letter, valid_input)

        expect(game).to receive(:puts).with("Invalid input. Try again:").twice
        game.player_input_token
      end
    end
  end

  describe "#create_players" do
    context "when 2 players are created loop stops" do
      before do
        allow(game).to receive(:request_name)
        allow(game).to receive(:assign_token)
      end

      it "receives #request_name twice" do
        expect(game).to receive(:request_name).twice
        game.create_players
      end

      it "receives #assign_token twice" do
        expect(game).to receive(:assign_token).twice
        game.create_players
      end
    end
  end

  describe "#request_next_move" do
    context "when entering a valid input (1-7)" do
      it "returns the integer of the valid input" do
        allow(game).to receive(:gets).and_return("3\n")
        expect(game.request_next_move).to eq(3)
      end
    end

    context "when entering invalid input twice and then a valid input" do
      before do
        invalid_symbol = "+\n"
        invalid_letter = "g\n"
        valid_input = "5\n"
        allow(game).to receive(:gets).and_return(invalid_symbol, invalid_letter, valid_input)
      end

      it "receives invalid message twice" do
        expect(game).to receive(:puts).with("Invalid input. Please enter a number between 1 and 7:").twice
        game.request_next_move
      end

      it "returns the integer of the valid_input" do
        allow(game).to receive(:puts)
        expect(game.request_next_move).to eq(5)
      end
    end
  end

  describe "#column_has_empty_slot?" do
    context "when the column is full" do
      it "returns false" do
        move = 3
        game.board = Array.new(6) { Array.new(7, "X") }
        expect(game.column_has_empty_slot?(move)).to eq(false)
      end
    end
    context "when the column is not full" do
      it "returns true" do
        move = 5
        expect(game.column_has_empty_slot?(move)).to eq(true)
      end
    end
  end

  describe "#verified_move" do
    context "when #column_has_emtpy_slot? is false twice" do
      it "receives twice invalid message" do
        allow(game).to receive(:request_next_move)
        allow(game).to receive(:column_has_empty_slot?).and_return(false, false, true)
        expect(game).to receive(:puts).with("Column already complete. Please choose another column:").twice
        game.verified_move
      end
    end

    context "when #column_has emtpy_slot? is true" do
      it "returns next move" do
        allow(game).to receive(:request_next_move).and_return(7)
        allow(game).to receive(:column_has_empty_slot?).and_return(true)
        expect(game.verified_move).to eq(7)
      end
    end
  end

  describe "#find_free_slot" do
    context "when next_move is passed in as argument" do
      it "returns the index of the row with the next free slot in that column" do
        next_move = 3
        game.board[0][2] = "X"
        return_value = game.find_free_slot(next_move)
        expect(return_value).to eq(1)
      end
    end
  end

  describe "#update_free_slot_with_player_token" do
    before do
      game.current_player = game.player1
      game.current_player[:token] = "\u232C"

    end

    it "updates the free slot with player token" do
      index_row = 1
      next_move = 3
      game.update_free_slot_with_player_token(index_row, next_move)
      expect(game.board[index_row][next_move - 1]).to eq("\u232C")
    end

    it "saves index_row as first value of @last_token_position and next_move - 1 as second" do
      index_row = 1
      next_move = 3
      game.update_free_slot_with_player_token(index_row, next_move)
      expect(game.last_token_position).to eq([index_row, next_move - 1])
    end
  end

  describe "#update_current_player" do
    context "when current player is player 1" do
      it "updates current player to player 2" do
        game.current_player = game.player1
        game.update_current_player
        expect(game.current_player).to eq(game.player2)
      end
    end

    context "when current player is player 2" do
      it "updates current player to player 1" do
        game.current_player = game.player2
        game.update_current_player
        expect(game.current_player).to eq(game.player1)
      end
    end
  end

  describe "#play_game" do
    before do
      allow(game).to receive(:create_players)
      allow(game).to receive(:visualizing_board)
      allow(game).to receive(:make_player_move)
      allow(game).to receive(:update_current_player)
    end

    context "when win? is true" do
      it "stops the loop" do
        allow(game).to receive(:win?).and_return(true)
        allow(game).to receive(:puts)
        expect(game).not_to receive(:board_is_full?)
        game.play_game
      end

      it "receives win message once" do
        allow(game).to receive(:win?).and_return(true)

        expect(game).to receive(:puts).with("#{game.current_player[:name]} wins the game!").once
        game.play_game
      end
    end

    context "when board_is full? is true" do
      it "stops the loop" do
        allow(game).to receive(:win?)
        allow(game).to receive(:board_is_full?).and_return(true)
        allow(game).to receive(:puts)
        expect(game).not_to receive(:update_current_player)
        game.play_game
      end

      it "receives board is full message once" do
        allow(game).to receive(:win?)
        allow(game).to receive(:board_is_full?).and_return(true)
        allow(game).to receive(:puts).with("Tie. Board is full. Nobody won.")
        expect(game).to receive(:puts).with("Tie. Board is full. Nobody won.").once
        game.play_game
      end
    end
  end

  describe "#board_is_full?" do
    before do
      game.board = Array.new(6) { Array.new(7, "X") }
    end
    context "when board is full" do
      it "returns true" do
        expect(game.board_is_full?).to be true
      end
    end

    context "even if board has only one empty slot" do
      it "returns false" do
        game.board[5][0] = " "
        expect(game.board_is_full?).to be false
      end
    end
  end

  describe "#from_lower_left_to_upper_right?" do
    context "when 4 token are in an diagonal pattern" do
      it "returns true" do
        game.board = Array.new(6) { Array.new(7, " ") }
        game.board[0][0] = "\u232C"
        game.board[1][1] = "\u232C"
        game.board[2][2] = "\u232C"
        game.board[3][3] = "\u232C"
        game.last_token_position = [3, 3]
        game.current_player[:token] = "\u232C"
        expect(game.from_lower_left_to_upper_right?).to be true
      end
    end

    context "when no diagonal pattern on the board" do
      it "returns false" do
        game.current_player[:token] = "\u232C"
        game.last_token_position = [3, 2]
        game.last_token_position = [2, 1]
        game.last_token_position = [1, 0]
        expect(game.from_lower_left_to_upper_right?).to be false
      end
    end
  end

  describe "#from_lower_right_to_upper_left?" do
    context "when 4 token are in an diagonal pattern" do
      it "returns true" do
        game.board = Array.new(6) { Array.new(7, " ") }
        game.board[0][6] = "\u232C"
        game.board[1][5] = "\u232C"
        game.board[2][4] = "\u232C"
        game.board[3][3] = "\u232C"
        game.last_token_position = [3, 3]
        game.current_player[:token] = "\u232C"
        expect(game.from_lower_right_to_upper_left?).to be true
      end
    end

    context "when no diagonal pattern on the board" do
      it "returns false" do
        game.current_player[:token] = "\u232C"
        game.last_token_position = [3, 4]
        game.last_token_position = [2, 5]
        game.last_token_position = [1, 6]
        expect(game.from_lower_right_to_upper_left?).to be false
      end
    end
  end

  describe "#diagonal_pattern?" do
    context "when #from_lower_left_to_upper_right? is true" do
      it "returns true" do
        allow(game).to receive(:from_lower_left_to_upper_right?).and_return(true)
        allow(game).to receive(:from_lower_right_to_upper_left?).and_return(false)
        expect(game.diagonal_pattern?).to be true
      end
    end

    context "when #from_lower_right_to_upper_left?" do
      it "returns true" do
        allow(game).to receive(:from_lower_left_to_upper_right?).and_return(false)
        allow(game).to receive(:from_lower_right_to_upper_left?).and_return(true)
        expect(game.diagonal_pattern?).to be true
      end
    end

    context "when none of the helper functions is true" do
      it "returns false" do
        allow(game).to receive(:from_lower_left_to_upper_right?).and_return(false)
        allow(game).to receive(:from_lower_right_to_upper_left?).and_return(false)
        expect(game.diagonal_pattern?).to be false
      end
    end
  end

  describe "#horizontal_pattern?" do
    context "when row where last token was placed contains 4 tokens in a row" do
      it "returns true" do
        game.current_player[:token] = "\u232C"
        game.last_token_position = [3, 3]
        game.board[3][3] = "\u232C"
        game.board[3][4] = "\u232C"
        game.board[3][5] = "\u232C"
        game.board[3][6] = "\u232C"
        expect(game.horizontal_pattern?).to be true
      end
    end

    context "when row where last token was placed does not contain 4 tokens in a row" do
      it "returns false" do
        game.current_player[:token] = "\u232C"
        game.last_token_position = [3, 3]
        game.board[3][3] = "\u232C"
        game.board[3][4] = "\u232C"
        game.board[3][5] = "\u232C"
        expect(game.horizontal_pattern?).to be false
      end
    end
  end

  describe "#win?" do
    context "when diagonal_pattern is true" do
      it "returns true" do
        allow(game).to receive(:diagonal_pattern?).and_return(true)
        allow(game).to receive(:horizontal_pattern?).and_return(false)
        expect(game.win?).to be true
      end
    end

    context "when horizontal_pattern is true" do
      it "returns true" do
        allow(game).to receive(:diagonal_pattern?).and_return(false)
        allow(game).to receive(:horizontal_pattern?).and_return(true)
        expect(game.win?).to be true
      end
    end

    context "when none of the helper functions is true" do
      it "returns false" do
        allow(game).to receive(:diagonal_pattern?).and_return(false)
        allow(game).to receive(:horizontal_pattern?).and_return(false)
        expect(game.win?).to be false
      end
    end
  end
end
