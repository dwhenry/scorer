# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/b_cards'

RSpec.describe 'B Cards' do
  describe 'Using BIONIC ARM' do
    it 'when on a single card' do
      scores = Doomlings::Scorer.new([{ name: 'BIONIC ARM' }]).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: -1, final_b: 1)
    end

    it 'when multiple techlings' do
      scores = Doomlings::Scorer.new(
        [{ name: 'BIONIC ARM' }, { name: 'BINARY' }, { name: 'BINARY' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: -1, final_b: 3, total: 2)
    end

    it '1 for each techling' do
      scores = Doomlings::Scorer.new(
        [{ name: 'BIONIC ARM' }, { name: 'BINARY' }, { name: 'BINARY' }, { name: 'BINARY' }, { name: 'BINARY' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: -1, final_b: 5, total: 4)
    end
  end

  describe 'Using BOREDOM + other cards' do
    it 'add points when cards have effects' do
      scores = Doomlings::Scorer.new(
        [{ name: 'BOREDOM' }, zero_point_colourless_card]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: 0, final_b: 2, total: 2)
    end

    it 'does not add points when cards have no effects' do
      scores = Doomlings::Scorer.new(
        [{ name: 'BOREDOM' }, { name: 'ADORABLE' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: 0, final_b: 1, total: 1)
    end
  end

  describe 'Using BRANCHES + other cards' do
    it 'point for pairs of green cards in opponents hands' do
      scores = Doomlings::Scorer.new(
        [{ name: 'BRANCHES' }],
        [zero_point_green_card, zero_point_green_card],
        [zero_point_green_card, zero_point_green_card, zero_point_green_card]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(final_a: 0, final_b: 2, total: 2)
    end

    it "no points for green cards in the owner's hands" do
      scores = Doomlings::Scorer.new(
        [{ name: 'BRANCHES' }, zero_point_green_card, zero_point_green_card]
      ).scores

      expect(scores.get_player_score(0).total).to eq(0)
    end
  end
end
