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
end