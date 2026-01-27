# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/g_cards'

RSpec.describe 'G Cards' do
  describe 'GMO' do
    it 'scores -1 if no other traits' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GMO', attached_trait: :red }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: -1,
        final_a: -1,
        final_b: 0
      )
    end

    it 'scores only for scores which match the trait under test' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GMO', attached_trait: :red }, zero_point_red_card, zero_point_green_card, zero_point_purple_card, zero_point_blue_card, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 0,
        final_a: -1,
        final_b: 1
      )
    end

    it 'scores only for each card matching the trait' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GMO', attached_trait: :red }, zero_point_red_card, zero_point_red_card, zero_point_red_card, zero_point_blue_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 2,
        final_a: -1,
        final_b: 3
      )
    end
  end

  describe 'Gratitude' do
    it 'scores 0 if only colourless cards are present' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GRATITUDE' }, zero_point_colourless_card, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 0,
        final_a: 0,
        final_b: 0
      )
    end

    it 'scores 4 if all colours are present' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GRATITUDE' }, zero_point_red_card, zero_point_green_card, zero_point_purple_card, zero_point_blue_card, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_b: 4
      )
    end

    it 'supports multi-coloured cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'GRATITUDE' }, { name: 'BULLHEADED' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_b: 2
      )
    end
  end
end
