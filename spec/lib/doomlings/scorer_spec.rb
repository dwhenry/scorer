# frozen_string_literal: true

require 'rails_helper'
require 'doomlings/scorer'
require 'doomlings/cards/a_cards'
require 'doomlings/cards/catastrophe_cards'

RSpec.describe Doomlings::Scorer do
  describe 'Using ACROBATIC card' do
    let(:acrobatic_card) { { name: 'ACROBATIC' } }

    it 'single card gives the user a total score of 2' do
      scores = described_class.new([acrobatic_card]).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 2)
    end

    it 'each card is worth 2 base points' do
      scores = described_class.new(
        [acrobatic_card, acrobatic_card, acrobatic_card],
        [acrobatic_card, acrobatic_card],
        [acrobatic_card]
      ).scores

      expect(scores.get_player_score(0)).to have_attributes(total: 6)
      expect(scores.get_player_score(1)).to have_attributes(total: 4)
      expect(scores.get_player_score(2)).to have_attributes(total: 2)

      # Every Acrobatic card is worth 2
      [0, 1, 2].each do |player|
        scores.get_player_score(player).card_scores.each do |c|
          expect(c).to have_attributes(total: 2, final_a: 2, final_b: 0)
        end
      end
    end
  end

  describe 'Using ALTRUISTIC card' do
    let(:altruistic_with_gene_pool_4) { { name: 'ALTRUISTIC', gene_pool_size: 4 } }

    it 'single card gives the user a total score based on metadata' do
      scores = described_class.new([altruistic_with_gene_pool_4]).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 4, final_a: 0)
    end

    it 'multiple cards give the user a total score based on metadata' do
      scores = described_class.new(
        [altruistic_with_gene_pool_4, altruistic_with_gene_pool_4],
        [{ name: 'ALTRUISTIC', gene_pool_size: 6 }]
      ).scores
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 4)
      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(total: 4)
      expect(scores.get_player_score(1).get_card_score_by_index(0)).to have_attributes(total: 6)
    end

    it 'missing metadata throws a missing metadata error' do
      expect { described_class.new([{ name: 'ALTRUISTIC', missing: 4 }]).scores }
        .to raise_error('Missing metadata field gene_pool_size')
    end

    it 'invalid metadata throws an invalid data error' do
      scorer = described_class.new([{ name: 'ALTRUISTIC', gene_pool_size: 'apples' }])
      expect { scorer.scores }.to raise_error('invalid data for metadata field gene_pool_size')
    end
  end

  describe 'Using APEX PREDATOR card' do
    let(:apex_predator_card) { { name: 'APEX PREDATOR' } }
    let(:acrobatic_card) { { name: 'ACROBATIC' } }

    it 'gives 8 points when player has most cards' do
      scores = described_class.new(
        [apex_predator_card, acrobatic_card, acrobatic_card],
        [acrobatic_card]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 8, final_a: 4, final_b: 4)
    end

    it 'gives 4 points when another player has same number of cards' do
      scores = described_class.new(
        [apex_predator_card, acrobatic_card],
        [acrobatic_card, acrobatic_card]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 4, final_a: 4, final_b: 0)
    end

    it 'gives 4 points when another player has more cards' do
      scores = described_class.new(
        [apex_predator_card],
        [acrobatic_card, acrobatic_card]
      ).scores

      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 4, final_a: 4, final_b: 0)
    end
  end

  describe 'Using AI TAKEOVER catastrophe card' do
    let(:altruistic_card) { { name: 'ALTRUISTIC', gene_pool_size: 5 } }
    let(:acrobatic_card) { { name: 'ACROBATIC' } }
    let(:ai_takeover) { { name: 'AI TAKEOVER' } }

    it 'sets all colourless cards to 2 points' do
      scores = described_class.new(
        [altruistic_card, acrobatic_card],
        [altruistic_card]
      ).add_catastrophes([ai_takeover]).scores

      # ALTRUISTIC cards should be worth 2, ACROBATIC should be worth 2
      expect(scores.get_player_score(0).get_card_score_by_index(0)).to have_attributes(total: 2, final_a: 2, final_b: 0)
      expect(scores.get_player_score(0).get_card_score_by_index(1)).to have_attributes(total: 2, final_a: 2, final_b: 0)
      expect(scores.get_player_score(1).get_card_score_by_index(0)).to have_attributes(total: 2, final_a: 2, final_b: 0)
    end
  end

  describe 'Using BIOENGINEERED PLAGUE catastrophe card' do
    let(:acrobatic_card) { { name: 'ACROBATIC' } }
    let(:adorable_card) { { name: 'ADORABLE' } }

    it 'removes specified cards from players hands' do
      bio_plague = { name: 'BIOENGINEERED PLAGUE', discard: ['ACROBATIC', 'ADORABLE'] }

      scores = described_class.new(
        [acrobatic_card, adorable_card],
        [adorable_card, acrobatic_card]
      ).add_catastrophes([bio_plague]).scores

      # Each player should have only 1 card left
      expect(scores.get_player_score(0).card_scores.length).to eq(1)
      expect(scores.get_player_score(1).card_scores.length).to eq(1)

      # Player 1 should have ADORABLE (4 points), Player 2 should have ACROBATIC (2 points)
      expect(scores.get_player_score(0).total).to eq(4)
      expect(scores.get_player_score(1).total).to eq(2)
    end

    it 'raises error when card to discard not found' do
      bio_plague = { name: 'BIOENGINEERED PLAGUE', discard: ['NONEXISTENT', 'ACROBATIC'] }

      scorer = described_class.new(
        [acrobatic_card],
        [acrobatic_card]
      ).add_catastrophes([bio_plague])

      expect { scorer.scores }.to raise_error(/could not find card to discard/)
    end
  end

  describe 'GameScore' do
    it 'identifies winning player' do
      scores = described_class.new(
        [{ name: 'ADORABLE' }],  # 4 points
        [{ name: 'ACROBATIC' }]  # 2 points
      ).scores

      expect(scores.winning_player_indices).to eq([0])
    end

    it 'identifies multiple winners in a tie' do
      scores = described_class.new(
        [{ name: 'ADORABLE' }],  # 4 points
        [{ name: 'ADORABLE' }]   # 4 points
      ).scores

      expect(scores.winning_player_indices).to contain_exactly(0, 1)
    end
  end
end
