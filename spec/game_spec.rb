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
end
