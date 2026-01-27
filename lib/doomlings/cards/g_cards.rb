# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  CardContainer.add_basic_card('GALACTIC DRIFT', :colourless, 'Classic', 0)
  CardContainer.add_basic_card('GELATINOUS', :red, 'Mythlings', 1)
  CardContainer.add_basic_card('GILLS', :blue, 'Classic', 1)
  CardContainer.add_basic_card('GLACIAL DRIFT', :blue, 'Classic', 0)

  gmo = PlayerCard.new(
    name: 'GMO',
    type: :colourless,
    pack: 'Techlings',
    metadata_required: [[:attached_trait, :trait]]
  )
  gmo.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = -1
  end
  gmo.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    chosen_traits = Array(inst.metadata[:attached_trait])
    player_cards_matching_trait = all_player_cards[current_player].select do |card|
      card.card.type.any? { |type| chosen_traits.include?(type) }
    end
    inst.final_b = player_cards_matching_trait.length
  end
  CardContainer.add_card(gmo)

  gratitude = PlayerCard.new(
    name: 'GRATITUDE',
    type: :colourless,
    pack: 'Classic'
  )
  gratitude.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 0
  end
  gratitude.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    current_player_cards = all_player_cards[current_player]
    unique_player_traits = current_player_cards
      .flat_map { |card| card.card.type }
      .reject { |c| c == :colourless || c == :catastrophe }
      .uniq
    inst.final_b = unique_player_traits.length
  end
  CardContainer.add_card(gratitude)

  CardContainer.add_basic_card('GREY HAT', :colourless, 'Techlings', -1)
end
