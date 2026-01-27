# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Doomlings::Scorer do
  describe 'basic scoring' do
    it 'calculates score for ACROBATIC' do
      scorer = described_class.new([
        [{ name: 'ACROBATIC' }]
      ])

      game_score = scorer.calc
      expect(game_score.players[0].total).to eq(5)
    end

    it 'calculates score for ALTRUISTIC' do
      scorer = described_class.new([
        [{ name: 'ALTRUISTIC' }, zero_point_colourless_card],
        [zero_point_colourless_card]
      ])

      game_score = scorer.calc
      expect(game_score.players[0].total).to eq(3)
    end

    it 'calculates score for APEX PREDATOR' do
      scorer = described_class.new([
        [{ name: 'APEX PREDATOR' }, zero_point_red_card, zero_point_red_card],
        []
      ])

      game_score = scorer.calc
      expect(game_score.players[0].total).to eq(11)
    end
  end

  describe 'catastrophe cards' do
    it 'applies AI TAKEOVER' do
      scorer = described_class.new([
        [zero_point_purple_card, zero_point_purple_card],
        [zero_point_colourless_card]
      ])

      scorer.add_catastrophe_card(name: 'AI TAKEOVER')
      game_score = scorer.calc

      expect(game_score.players[0].total).to eq(-2)
      expect(game_score.players[1].total).to eq(0)
    end

    it 'applies BIOENGINEERED PLAGUE' do
      scorer = described_class.new([
        [zero_point_green_card, zero_point_green_card, zero_point_green_card]
      ])

      scorer.add_catastrophe_card(name: 'BIOENGINEERED PLAGUE')
      game_score = scorer.calc

      expect(game_score.players[0].total).to eq(-3)
    end
  end

  describe Doomlings::GameScore do
    it 'calculates total scores and sorts players' do
      scorer = Doomlings::Scorer.new([
        [{ name: 'ACROBATIC' }],  # 5 points
        [{ name: 'APEX PREDATOR' }, zero_point_red_card, zero_point_red_card],  # 11 points
        [zero_point_colourless_card]  # 0 points
      ])

      game_score = scorer.calc

      expect(game_score.players[0].total).to eq(5)
      expect(game_score.players[1].total).to eq(11)
      expect(game_score.players[2].total).to eq(0)

      sorted = game_score.sorted
      expect(sorted[0].total).to eq(11)
      expect(sorted[1].total).to eq(5)
      expect(sorted[2].total).to eq(0)
    end
  end
end
