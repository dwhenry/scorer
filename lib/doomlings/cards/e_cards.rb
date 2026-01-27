# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  CardContainer.add_basic_card('ECHOLOCATION', :blue, 'Classic', 4)
  CardContainer.add_basic_card('ECLIPSE', :purple, 'Classic', 0)
  CardContainer.add_basic_card('EFFIGIAL', :colourless, 'Mythlings', -3)

  egg_clusters = PlayerCard.new(
    name: 'EGG CLUSTERS',
    type: :blue,
    pack: 'Classic'
  )
  egg_clusters.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = -1
  end
  egg_clusters.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    blue_cards = player_cards.select { |c| c.type.include?(:blue) }
    inst.final_b = blue_cards.length
  end
  CardContainer.add_card(egg_clusters)

  CardContainer.add_basic_card('EGG PREDATION', :purple, 'Dinolings', 1)
  CardContainer.add_basic_card('ELECTROMAGNETIC', :purple, 'Techlings', 1)
  CardContainer.add_basic_card('ELONGATED NECK', :blue, 'Dinolings', 1)
  CardContainer.add_basic_card('ELOQUENCE', :colourless, 'Classic', 1)

  elven_ears = PlayerCard.new(
    name: 'ELVEN EARS',
    type: :green,
    pack: 'Mythlings'
  )
  elven_ears.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = -1
  end
  elven_ears.define_singleton_method(:calc_b) do |inst, all_player_cards, _current_player|
    all_cards = all_player_cards.flatten
    mythling_cards = all_cards.select { |card| card.card.pack == 'Mythlings' }
    inst.final_b = mythling_cards.length
  end
  CardContainer.add_card(elven_ears)

  CardContainer.add_basic_card('ENDURANCE', :red, 'Classic', 1)
  CardContainer.add_basic_card('ENLIGHTENMENT', :purple, 'Classic', 0)
end
