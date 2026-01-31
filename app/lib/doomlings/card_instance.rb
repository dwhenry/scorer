# frozen_string_literal: true

module Doomlings
  class CardInstance
    attr_accessor :card, :trait_points, :overrides, :final_a, :final_b, :metadata

    def initialize(card, metadata = {})
      @card = card
      @metadata = metadata.transform_keys(&:to_sym)
      @trait_points = 0
      @overrides = {}
      @final_a = 0
      @final_b = 0
    end

    def type
      overrides[:type] || card.type
    end

    def set_override(key, value)
      @overrides[key.to_sym] = value
    end
  end
end
