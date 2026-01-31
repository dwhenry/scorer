# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  CardContainer.add_basic_card('DEEP ROOTS', :green, 'Classic', 2)
  CardContainer.add_basic_card('DELICIOUS', :colourless, 'Classic', 4)
  CardContainer.add_basic_card('DERMAL ARMOR', :colourless, 'Dinolings', 2)
  CardContainer.add_basic_card('DESTINED', :colourless, 'Mythlings', 4)
  CardContainer.add_basic_card('DIAPHANOUS WINGS', :blue, 'Mythlings', -1)
  CardContainer.add_basic_card('DIRECTLY REGISTER', :purple, 'Classic', 1)
  CardContainer.add_basic_card('DOTING', :colourless, 'Classic', 2)

  # Bonus 4 points if "all 4 colours" are present
  dragon_heart = PlayerCard.new(
    name: 'DRAGON HEART',
    type: :red,
    pack: 'Mythlings'
  )
  dragon_heart.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 1
  end
  dragon_heart.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    current_player_cards = all_player_cards[current_player]

    valid_colours = %i[purple green red blue]
    unique_matching_colours = current_player_cards
      .flat_map { |c| c.card.type }
      .select { |colour| valid_colours.include?(colour) }
      .uniq

    inst.final_b = unique_matching_colours.length == valid_colours.length ? 4 : 0
  end
  CardContainer.add_card(dragon_heart)

  CardContainer.add_basic_card('DREAMER', :purple, 'Classic', 1)
end
