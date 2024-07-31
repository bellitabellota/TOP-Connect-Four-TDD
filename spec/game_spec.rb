require_relative "../lib/Game"

describe Game do
  subject(:game) { described_class.new }

  describe "#request_name" do
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return("Pete")
      game.request_name
    end

    context "when no player name has been assigned yet" do
      it "assigns name to player 1" do
        expect(game.player1[:name]).to eq("Pete")
      end
    end

    context "when player1 has name assigned" do
      it "assigns name to player 2" do
        allow(game).to receive(:gets).and_return("Carl")
        game.request_name
        expect(game.player2[:name]).to eq("Carl")
      end
    end
  end
end