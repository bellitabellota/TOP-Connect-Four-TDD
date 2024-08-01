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

  describe "assign_token" do
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
end