# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  CardContainer.add_basic_card('ICY', :blue, 'Mythlings', 3)

  immunity = PlayerCard.new(
    name: 'IMMUNITY',
    type: :blue,
    pack: 'Classic'
  )
  immunity.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 4
  end
  immunity.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    current_player_cards = all_player_cards[current_player]
    # TODO: Fix me - this only works if the instance is put back.
    negative_face_value_traits_count = current_player_cards.count { |c| c.final_a < 0 }
    inst.final_b = negative_face_value_traits_count * 2
  end
  CardContainer.add_card(immunity)

  CardContainer.add_basic_card('IMPATIENCE', :purple, 'Classic', 1)
  CardContainer.add_basic_card('INTROSPECTIVE', :colourless, 'Classic', 1)
  CardContainer.add_basic_card('INVENTIVE', :purple, 'Classic', 1)
  CardContainer.add_basic_card('IRIDESCENT SCALES', :blue, 'Classic', 1)
end
