# frozen_string_literal: true
# require 'doomlings/doomlings'

class GameController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:calculate_score]

  def index
    @packs = Doomlings::PACK_TYPES
    @colors = Doomlings::TRAIT_CARD_TYPES
    @cards = load_all_cards
    @catastrophe_cards = load_catastrophe_cards
  end

  def calculate_score
    players_cards = params[:players] || []
    catastrophe_names = params[:catastrophes] || []

    begin
      # Initialize scorer with players
      scorer = Doomlings::Scorer.new(players_cards.map { |cards| convert_cards(cards) })

      # Add catastrophe cards
      catastrophe_names.each do |cat_name|
        scorer.add_catastrophe_card(name: cat_name)
      end

      # Calculate scores
      game_score = scorer.calc

      # Format response
      response_data = {
        players: game_score.players.map do |player_score|
          {
            total: player_score.total,
            cards: player_score.cards.map do |card_score|
              {
                name: card_score.name,
                finalA: card_score.final_a,
                finalB: card_score.final_b,
                total: card_score.total
              }
            end
          }
        end
      }

      render json: response_data
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def load_all_cards
    # Group cards by color and pack
    cards_by_color = {}

    Doomlings::CardContainer.all_cards.each do |name, card|
      next if card.type.include?(:catastrophe)

      card.type.each do |color|
        cards_by_color[color] ||= {}
        cards_by_color[color][card.pack] ||= []
        cards_by_color[color][card.pack] << {
          name: name,
          pack: card.pack,
          type: card.type,
          metadata_required: card.metadata_required
        }
      end
    end

    cards_by_color
  end

  def load_catastrophe_cards
    Doomlings::CardContainer.all_cards.select do |_name, card|
      card.type.include?(:catastrophe)
    end.map do |name, card|
      {
        name: name,
        pack: card.pack,
        metadata_required: card.metadata_required
      }
    end
  end

  def convert_cards(cards)
    cards.map do |card|
      card_data = { name: card['name'] }
      card_data[:metadata] = card['metadata'].symbolize_keys if card['metadata'].present?
      card_data
    end
  end
end
