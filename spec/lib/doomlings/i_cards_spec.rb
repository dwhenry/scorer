# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/i_cards'

RSpec.describe 'I Cards' do
  describe 'IMMUNITY' do
    it 'base scores 4' do
      scores = Doomlings::Scorer.new(
        [{ name: 'IMMUNITY' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: 4,
        final_b: 0,
        total: 4
      )
    end

    it 'scores +2 for each trait with negative base value, but only negative traits' do
      scores = Doomlings::Scorer.new(
        [
          { name: 'IMMUNITY' },
          { name: 'ELVEN EARS' },
          zero_point_red_card, zero_point_green_card, zero_point_purple_card, zero_point_blue_card, zero_point_colourless_card
        ]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_a: -1
      )
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_b: 2
      )
    end
  end
end
