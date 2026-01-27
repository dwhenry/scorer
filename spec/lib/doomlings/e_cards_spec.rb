# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/e_cards'

RSpec.describe 'E Cards' do
  describe 'Using EGG CLUSTERS + other cards' do
    it 'single card' do
      scores = Doomlings::Scorer.new(
        [{ name: 'EGG CLUSTERS' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 0,
        final_a: -1,
        final_b: 1
      )
    end

    it '+1 point for each blue card' do
      scores = Doomlings::Scorer.new(
        [{ name: 'EGG CLUSTERS' }, zero_point_blue_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
    end

    it 'no points for other colour cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'EGG CLUSTERS' }, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 0,
        final_a: -1,
        final_b: 1
      )
    end

    it 'multiple egg clusters grow together' do
      scores = Doomlings::Scorer.new(
        [{ name: 'EGG CLUSTERS' }, { name: 'EGG CLUSTERS' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
    end
  end

  describe 'ELVEN EARS' do
    it 'single card' do
      scores = Doomlings::Scorer.new(
        [{ name: 'ELVEN EARS' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 0,
        final_a: -1,
        final_b: 1
      )
    end

    it '1 point for each mythling card (including itself)' do
      scores = Doomlings::Scorer.new(
        [{ name: 'ELVEN EARS' }, { name: 'ANCIENT' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
    end

    it 'no points for other pack cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'ELVEN EARS' }, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: -1,
        final_b: 1
      )
    end

    it 'multiple elven ears grow together' do
      scores = Doomlings::Scorer.new(
        [{ name: 'ELVEN EARS' }, { name: 'ELVEN EARS' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_a: -1,
        final_b: 2
      )
    end

    it 'mythlings in other players trait piles' do
      scores = Doomlings::Scorer.new(
        [{ name: 'ELVEN EARS' }],
        [{ name: 'ANCIENT' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 1,
        final_a: -1,
        final_b: 2
      )
    end
  end
end
