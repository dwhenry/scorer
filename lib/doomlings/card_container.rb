# frozen_string_literal: true

require_relative 'card'
require_relative 'card_instance'

module Doomlings
  class CardContainer
    @cards = {}

    class << self
      def add_card(card)
        raise "Duplicate card name #{card.name}" if @cards.key?(card.name)

        @cards[card.name] = card
      end

      def add_basic_card(name, colours, pack, score)
        card = PlayerCard.new(name: name, type: colours, pack: pack)
        card.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
          inst.final_a = score
        end
        add_card(card)
      end

      def find_card(name)
        card = @cards[name]
        raise "Unknown card: #{name}" if card.nil?

        card
      end

      def get_card(name, metadata = {})
        card = find_card(name)
        inst = CardInstance.new(card, metadata)

        # Validate required metadata
        card.metadata_required.each do |key, _type|
          unless metadata.key?(key) || metadata.key?(key.to_s)
            raise "Missing metadata field #{key}"
          end
        end

        inst
      end

      def reset!
        @cards = {}
      end

      def all_cards
        @cards
      end
    end
  end
end
