# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  ai_takeover = CatastropheCard.new(
    name: 'AI TAKEOVER',
    type: :catastrophe,
    pack: 'Classic'
  )
  ai_takeover.define_singleton_method(:calc_c) do |_inst, all_player_cards|
    colourless_cards = all_player_cards.flat_map do |player_cards|
      player_cards.select { |inst| inst.type.include?(:colourless) }
    end

    colourless_cards.each do |inst|
      inst.final_a = 2
      inst.final_b = 0
    end
  end
  CardContainer.add_card(ai_takeover)

  bio_plague = CatastropheCard.new(
    name: 'BIOENGINEERED PLAGUE',
    type: :catastrophe,
    pack: 'Techlings',
    metadata_required: [[:discard, :card_per_person]]
  )
  bio_plague.define_singleton_method(:calc_c) do |inst, all_player_cards|
    raise 'discard is not an array' unless inst.metadata[:discard].is_a?(Array)

    all_player_cards.each_with_index do |player_cards, position|
      card_name = inst.metadata[:discard][position]
      raise "no card selected to discard for Player #{position + 1}" if card_name.nil?

      removed = false
      player_cards.each_with_index do |card_inst, index|
        if !removed && card_inst.card.name == card_name
          removed = true
          player_cards.delete_at(index)
        end
      end

      unless removed
        raise "could not find card to discard: #{card_name} for Player #{position + 1}"
      end
    end
  end
  CardContainer.add_card(bio_plague)

  # TODO: Additional catastrophe cards to be implemented
  # - EYES OPEN FROM BEHIND THE STARS
  # - DENIAL
  # - DEUS EX MACHINA
  # - GLACIAL MELTDOWN
  # - GREY GOO
  # - ICE AGE
  # - IMPACT EVENT
end
