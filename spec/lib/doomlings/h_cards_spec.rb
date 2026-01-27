# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/h_cards'

RSpec.describe 'H Cards' do
  describe 'HEAT VISION' do
    it 'scores 0 if no other red cards' do
      scores = Doomlings::Scorer.new(
        [],
        [{ name: 'HEAT VISION' }]
      ).scores
      expect(scores.get_player_score(1).total).to eq(0)
    end

    it 'scores 1 for each other red card' do
      scores = Doomlings::Scorer.new(
        [],
        [{ name: 'HEAT VISION' }, zero_point_red_card, zero_point_red_card]
      ).scores
      expect(scores.get_player_score(1).total).to eq(2)
    end
  end

  describe 'HYPER-MYELINATION' do
    it 'single card gives the user a total score of based on metadata' do
      scores = Doomlings::Scorer.new([], [{ name: 'HYPER-MYELINATION', biggest_gene_pool_size: 4 }]).scores
      expect(scores.get_player_score(1).total).to eq(4)
    end

    it 'multiple cards give the user a total score of based on metadata' do
      scores = Doomlings::Scorer.new(
        [],
        [{ name: 'HYPER-MYELINATION', biggest_gene_pool_size: 4 }, { name: 'HYPER-MYELINATION', biggest_gene_pool_size: 4 }],
        [{ name: 'HYPER-MYELINATION', biggest_gene_pool_size: 4 }]
      ).scores
      expect(scores.get_player_score(1).total).to eq(8)
      expect(scores.get_player_score(2).total).to eq(4)
    end

    it 'missing metadata raises a missing metadata error' do
      expect { Doomlings::Scorer.new([], [{ name: 'HYPER-MYELINATION', missing: 4 }]) }
        .to raise_error('Missing metadata field biggest_gene_pool_size')
    end
  end
end
