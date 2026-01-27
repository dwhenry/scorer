# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/f_cards'

RSpec.describe 'F Cards' do
  describe 'Using FAITH + other cards' do
    it 'faith card just has base points' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FAITH', fromColour: :colourless, toColour: :blue }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 4,
        final_a: 4,
        final_b: 0
      )
    end

    it 'faith card can change colours to effect total' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FAITH', fromColour: :colourless, toColour: :blue }, { name: 'EGG CLUSTERS' }, zero_point_colourless_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 4,
        final_a: 4,
        final_b: 0
      )
      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_b: 3
      )
    end

    it 'faith card can change colours to reduce score' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FAITH', fromColour: :blue, toColour: :red }, { name: 'EGG CLUSTERS' }]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 4,
        final_a: 4,
        final_b: 0
      )

      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_b: 0
      )
    end
  end

  describe 'FORTUNATE' do
    it 'FORTUNATE when only card' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FORTUNATE' }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 3,
        final_a: 1,
        final_b: 2
      )
    end

    it 'when matching number of colour cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FORTUNATE' }, zero_point_red_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 1,
        final_a: 1,
        final_b: 0
      )
    end

    it 'when more green cards' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FORTUNATE' }, zero_point_green_card, zero_point_red_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 3,
        final_a: 1,
        final_b: 2
      )
    end

    it 'when less green' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FORTUNATE' }, zero_point_red_card, zero_point_red_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 1,
        final_a: 1,
        final_b: 0
      )
    end
  end

  describe 'Using FREE WILL' do
    it 'FREE WILL card just has base points' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FREE WILL', colour: :blue }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 2,
        final_a: 2,
        final_b: 0
      )
    end

    it 'FREE WILL can change colours to effect total' do
      scores = Doomlings::Scorer.new(
        [{ name: 'FREE WILL', colour: :blue }, { name: 'EGG CLUSTERS' }]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 2,
        final_a: 2,
        final_b: 0
      )

      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(
        final_b: 2
      )
    end
  end
end
