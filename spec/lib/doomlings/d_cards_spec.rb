# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/d_cards'

RSpec.describe 'D Cards' do
  describe 'Using DRAGON HEART card' do
    it 'scores 1 if there is not all 4 colours present' do
      scores = Doomlings::Scorer.new([{ name: 'DRAGON HEART' }]).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 1,
        final_a: 1,
        final_b: 0
      )
    end

    it 'scores 5 when all the colours are present' do
      scores = Doomlings::Scorer.new(
        [{ name: 'DRAGON HEART' }, zero_point_blue_card, zero_point_green_card, zero_point_red_card, zero_point_purple_card]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(
        total: 5,
        final_a: 1,
        final_b: 4
      )
    end
  end
end
