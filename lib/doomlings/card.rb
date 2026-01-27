# frozen_string_literal: true

module Doomlings
  TRAIT_CARD_TYPES = %i[colourless purple red green blue].freeze
  CATASTROPHE_CARD_TYPES = %i[catastrophe].freeze
  OTHER_CARD_TYPES = %i[none].freeze
  CARD_TYPES = (TRAIT_CARD_TYPES + CATASTROPHE_CARD_TYPES + OTHER_CARD_TYPES).freeze

  PACK_TYPES = [
    'Classic',
    'Special Edition',
    'multi-colour',
    'Dinolings',
    'Mythlings',
    'Techlings',
    'Meaning of Life',
    'Overlush'
  ].freeze

  METADATA_TYPES = %i[number trait card_type card_per_person].freeze

  class Card
    attr_accessor :name, :type, :pack, :effect, :metadata_required

    def initialize(name:, type:, pack:, effect: nil, metadata_required: [])
      @name = name
      @type = Array(type)
      @pack = pack
      @effect = effect
      @metadata_required = metadata_required
    end

    def calc_a(card_instance, all_player_cards, current_player)
      # Override in subclasses
    end

    def modify(card_instance, all_player_cards, current_player)
      # Override in subclasses if needed
    end

    def calc_b(card_instance, all_player_cards, current_player)
      # Override in subclasses if needed
    end

    def calc_c(card_instance, all_player_cards)
      # Override in subclasses for catastrophe cards
    end
  end

  class PlayerCard < Card
    # Must implement calc_a
  end

  class CatastropheCard < Card
    # Must implement calc_c
  end
end
