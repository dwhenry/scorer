# frozen_string_literal: true

require_relative 'card_container'

module Doomlings
  class Scorer
    attr_reader :all_player_cards, :catastrophe_cards

    def initialize(*cards_input)
      @all_player_cards = cards_input.map do |player_cards|
        player_cards.map do |player_input|
          name = player_input[:name] || player_input['name']
          CardContainer.get_card(name, player_input)
        end
      end
      @catastrophe_cards = []
    end

    def add_catastrophes(catastrophe_input)
      @catastrophe_cards += catastrophe_input.map do |player_input|
        name = player_input[:name] || player_input['name']
        CardContainer.get_card(name, player_input)
      end
      self
    end

    def scores
      # Phase 1: calc_a (base score) and apply modifiers
      all_player_cards.each_with_index do |player_cards, player_index|
        player_cards.each do |inst|
          inst.card.calc_a(inst, all_player_cards, player_index)
          inst.card.modify(inst, all_player_cards, player_index)
        end
      end

      # Phase 2: calc_b (modifiers based on traits)
      all_player_cards.each_with_index do |player_cards, player_index|
        player_cards.each do |inst|
          inst.card.calc_b(inst, all_player_cards, player_index)
        end
      end

      # Phase 3: calc_c (catastrophes)
      catastrophe_cards.each do |inst|
        inst.card.calc_c(inst, all_player_cards)
      end

      # Calculate scores
      player_scores = all_player_cards.map do |player_cards|
        card_scores = player_cards.map do |c|
          final_a = c.final_a
          final_b = c.final_b || 0
          CardScore.new(name: c.card.name, final_a: final_a, final_b: final_b, total: final_a + final_b)
        end
        PlayerScore.new(card_scores)
      end

      # Find winning players
      max_score = player_scores.map(&:total).max
      winning_players = player_scores.each_index.select { |i| player_scores[i].total == max_score }

      GameScore.new(winning_players, player_scores)
    end

    def get_player_cards(player_index)
      all_player_cards[player_index]
    end
  end

  class GameScore
    attr_reader :winning_player_indices, :players

    def initialize(winning_player_indices, players)
      @winning_player_indices = winning_player_indices
      @players = players
    end

    def get_player_score(player_index)
      raise "Player of index #{player_index} not found" if player_index >= players.length

      players[player_index]
    end
  end

  class PlayerScore
    attr_reader :total, :cards

    def initialize(cards)
      @cards = cards
      @total = cards.sum(&:total)
    end

    def get_card_score_by_index(card_index)
      raise "No card exists at index #{card_index}" if card_index >= cards.length

      cards[card_index]
    end
  end

  class CardScore
    attr_reader :name,:total, :final_a, :final_b, :final_c

    def initialize(name:, total:, final_a:, final_b: nil, final_c: nil)
      @name = name
      @total = total
      @final_a = final_a
      @final_b = final_b
      @final_c = final_c
    end
  end
end
