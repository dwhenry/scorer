# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  faith = PlayerCard.new(
    name: 'FAITH',
    type: :colourless,
    pack: 'Classic',
    metadata_required: [[:fromColour, :card_type], [:toColour, :card_type]]
  )
  faith.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 4
  end
  faith.define_singleton_method(:modify) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    from_colour = inst.metadata[:fromColour]
    to_colour = inst.metadata[:toColour]

    player_cards.each do |card|
      card.set_override('type', [to_colour]) if card.type.include?(from_colour)
    end
  end
  CardContainer.add_card(faith)

  CardContainer.add_basic_card('FANGS', :red, 'Classic', 1)
  CardContainer.add_basic_card('FEAR', :colourless, 'Classic', 1)
  CardContainer.add_basic_card('FECUNDITY', :green, 'Classic', 1)
  CardContainer.add_basic_card('FEY', :green, 'Mythlings', 1)
  CardContainer.add_basic_card('FINE MOTOR SKILLS', :purple, 'Classic', 2)
  CardContainer.add_basic_card('FIRE SKIN', :red, 'Classic', 3)
  CardContainer.add_basic_card('FLATULENCE', :colourless, 'Classic', 3)
  CardContainer.add_basic_card('FLIGHT', :blue, 'Classic', 2)
  CardContainer.add_basic_card('FLOURISH', :green, 'Classic', 0)

  fortunate = PlayerCard.new(
    name: 'FORTUNATE',
    type: :green,
    pack: 'Classic'
  )
  fortunate.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 1
  end
  fortunate.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    green_size = 0
    colours = {}

    player_cards.each do |card|
      card.type.each do |type|
        if type == :green
          green_size += 1
        else
          colours[type] ||= 0
          colours[type] += 1
        end
      end
    end

    max_size = colours.values.max || 0
    # only when more green than others
    inst.final_b = max_size < green_size ? 2 : 0
  end
  CardContainer.add_card(fortunate)

  free_will = PlayerCard.new(
    name: 'FREE WILL',
    type: :colourless,
    pack: 'multi-colour',
    metadata_required: [[:colour, :card_type]]
  )
  free_will.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 2
  end
  free_will.define_singleton_method(:modify) do |inst, _all_player_cards, _current_player|
    inst.set_override('type', [inst.metadata[:colour]])
  end
  CardContainer.add_card(free_will)

  CardContainer.add_basic_card('FRONDS', :green, 'Dinolings', 0)
  CardContainer.add_basic_card('FULFILLED', :colourless, 'Classic', 4)
end
