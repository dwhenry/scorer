# frozen_string_literal: true

require 'test_helper'
require 'doomlings/scorer'
require 'doomlings/cards/a_cards'
require 'doomlings/cards/catastrophe_cards'

class DoomlingsCorerTest < ActiveSupport::TestCase
  test 'single ACROBATIC card gives the user a total score of 2' do
    scores = Doomlings::Scorer.new([{ name: 'ACROBATIC' }]).scores
    assert_equal 2, scores.get_player_score(0).get_card_score_by_index(0).total
  end

  test 'each ACROBATIC card is worth 2 base points' do
    acrobatic = { name: 'ACROBATIC' }
    scores = Doomlings::Scorer.new(
      [acrobatic, acrobatic, acrobatic],
      [acrobatic, acrobatic],
      [acrobatic]
    ).scores

    assert_equal 6, scores.get_player_score(0).total
    assert_equal 4, scores.get_player_score(1).total
    assert_equal 2, scores.get_player_score(2).total

    # Every Acrobatic card is worth 2
    [0, 1, 2].each do |player|
      scores.get_player_score(player).card_scores.each do |c|
        assert_equal 2, c.total
        assert_equal 2, c.final_a
        assert_equal 0, c.final_b
      end
    end
  end

  test 'ALTRUISTIC card gives total score based on metadata' do
    scores = Doomlings::Scorer.new([{ name: 'ALTRUISTIC', gene_pool_size: 4 }]).scores
    card_score = scores.get_player_score(0).get_card_score_by_index(0)
    assert_equal 4, card_score.total
    assert_equal 0, card_score.final_a
  end

  test 'multiple ALTRUISTIC cards use their metadata' do
    scores = Doomlings::Scorer.new(
      [{ name: 'ALTRUISTIC', gene_pool_size: 4 }, { name: 'ALTRUISTIC', gene_pool_size: 4 }],
      [{ name: 'ALTRUISTIC', gene_pool_size: 6 }]
    ).scores

    assert_equal 4, scores.get_player_score(0).get_card_score_by_index(0).total
    assert_equal 4, scores.get_player_score(0).get_card_score_by_index(1).total
    assert_equal 6, scores.get_player_score(1).get_card_score_by_index(0).total
  end

  test 'ALTRUISTIC missing metadata throws error' do
    error = assert_raises(RuntimeError) do
      Doomlings::Scorer.new([{ name: 'ALTRUISTIC', missing: 4 }]).scores
    end
    assert_equal 'Missing metadata field gene_pool_size', error.message
  end

  test 'ALTRUISTIC invalid metadata throws error' do
    scorer = Doomlings::Scorer.new([{ name: 'ALTRUISTIC', gene_pool_size: 'apples' }])
    error = assert_raises(RuntimeError) do
      scorer.scores
    end
    assert_equal 'invalid data for metadata field gene_pool_size', error.message
  end

  test 'APEX PREDATOR gives 8 points when player has most cards' do
    scores = Doomlings::Scorer.new(
      [{ name: 'APEX PREDATOR' }, { name: 'ACROBATIC' }, { name: 'ACROBATIC' }],
      [{ name: 'ACROBATIC' }]
    ).scores

    card_score = scores.get_player_score(0).get_card_score_by_index(0)
    assert_equal 8, card_score.total
    assert_equal 4, card_score.final_a
    assert_equal 4, card_score.final_b
  end

  test 'APEX PREDATOR gives 4 points when another player has same number' do
    scores = Doomlings::Scorer.new(
      [{ name: 'APEX PREDATOR' }, { name: 'ACROBATIC' }],
      [{ name: 'ACROBATIC' }, { name: 'ACROBATIC' }]
    ).scores

    card_score = scores.get_player_score(0).get_card_score_by_index(0)
    assert_equal 4, card_score.total
    assert_equal 4, card_score.final_a
    assert_equal 0, card_score.final_b
  end

  test 'APEX PREDATOR gives 4 points when another player has more cards' do
    scores = Doomlings::Scorer.new(
      [{ name: 'APEX PREDATOR' }],
      [{ name: 'ACROBATIC' }, { name: 'ACROBATIC' }]
    ).scores

    card_score = scores.get_player_score(0).get_card_score_by_index(0)
    assert_equal 4, card_score.total
    assert_equal 4, card_score.final_a
    assert_equal 0, card_score.final_b
  end

  test 'AI TAKEOVER sets all colourless cards to 2 points' do
    scores = Doomlings::Scorer.new(
      [{ name: 'ALTRUISTIC', gene_pool_size: 5 }, { name: 'ACROBATIC' }],
      [{ name: 'ALTRUISTIC', gene_pool_size: 5 }]
    ).add_catastrophes([{ name: 'AI TAKEOVER' }]).scores

    # ALTRUISTIC cards should be worth 2, ACROBATIC should be worth 2
    assert_equal 2, scores.get_player_score(0).get_card_score_by_index(0).total
    assert_equal 2, scores.get_player_score(0).get_card_score_by_index(0).final_a
    assert_equal 0, scores.get_player_score(0).get_card_score_by_index(0).final_b

    assert_equal 2, scores.get_player_score(0).get_card_score_by_index(1).total
    assert_equal 2, scores.get_player_score(1).get_card_score_by_index(0).total
  end

  test 'BIOENGINEERED PLAGUE removes specified cards from players hands' do
    bio_plague = { name: 'BIOENGINEERED PLAGUE', discard: ['ACROBATIC', 'ADORABLE'] }

    scores = Doomlings::Scorer.new(
      [{ name: 'ACROBATIC' }, { name: 'ADORABLE' }],
      [{ name: 'ADORABLE' }, { name: 'ACROBATIC' }]
    ).add_catastrophes([bio_plague]).scores

    # Each player should have only 1 card left
    assert_equal 1, scores.get_player_score(0).card_scores.length
    assert_equal 1, scores.get_player_score(1).card_scores.length

    # Player 1 should have ADORABLE (4 points), Player 2 should have ACROBATIC (2 points)
    assert_equal 4, scores.get_player_score(0).total
    assert_equal 2, scores.get_player_score(1).total
  end

  test 'BIOENGINEERED PLAGUE raises error when card to discard not found' do
    bio_plague = { name: 'BIOENGINEERED PLAGUE', discard: ['NONEXISTENT', 'ACROBATIC'] }

    scorer = Doomlings::Scorer.new(
      [{ name: 'ACROBATIC' }],
      [{ name: 'ACROBATIC' }]
    ).add_catastrophes([bio_plague])

    error = assert_raises(RuntimeError) do
      scorer.scores
    end
    assert_match(/could not find card to discard/, error.message)
  end

  test 'identifies winning player' do
    scores = Doomlings::Scorer.new(
      [{ name: 'ADORABLE' }],  # 4 points
      [{ name: 'ACROBATIC' }]  # 2 points
    ).scores

    assert_equal [0], scores.winning_player_indices
  end

  test 'identifies multiple winners in a tie' do
    scores = Doomlings::Scorer.new(
      [{ name: 'ADORABLE' }],  # 4 points
      [{ name: 'ADORABLE' }]   # 4 points
    ).scores

    assert_equal [0, 1], scores.winning_player_indices
  end
end
