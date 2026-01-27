# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/c_cards'

RSpec.describe 'C Cards' do
  describe 'Using CAMOUFLAGE + other cards' do
    it 'addition points for each card in hand' do
      scores = Doomlings::Scorer.new(
        [{ name: 'CAMOUFLAGE', cards_in_hand: 5 }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 7,
        final_a: 2,
        final_b: 5
      )
    end
  end

  describe 'Using CRANIAL CREST + other cards' do
    it 'base score when only colourless cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'CRANIAL CREST' }, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 4,
        final_a: 4
      )
    end

    it 'scores -1 for each colourless card' do
      scores = Doomlings::Scorer.new(
        [{ name: 'CRANIAL CREST' }, zero_point_blue_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 3,
        final_a: 4,
        final_b: -1
      )
    end
  end
end
