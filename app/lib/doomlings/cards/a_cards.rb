# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  # Simple cards
  CardContainer.add_basic_card('ACROBATIC', %i[purple green], 'Classic', 2)
  CardContainer.add_basic_card('ADORABLE', :purple, 'Classic', 4)

  # Complex card with metadata
  altruistic = PlayerCard.new(
    name: 'ALTRUISTIC',
    type: :colourless,
    pack: 'Classic',
    metadata_required: [[:gene_pool_size, :number]]
  )
  altruistic.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 0
  end
  altruistic.define_singleton_method(:calc_b) do |inst, _all_cards, _player|
    unless inst.metadata[:gene_pool_size].is_a?(Integer)
      raise 'invalid data for metadata field gene_pool_size'
    end

    inst.final_b = inst.metadata[:gene_pool_size]
  end
  CardContainer.add_card(altruistic)

  CardContainer.add_basic_card('ANCIENT', :red, 'Mythlings', 2)
  CardContainer.add_basic_card('ANTLERS', :red, 'Classic', 3)

  # Card with complex logic
  apex_predator = PlayerCard.new(
    name: 'APEX PREDATOR',
    type: :red,
    pack: 'Classic'
  )
  apex_predator.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 4
  end
  apex_predator.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    points = 4
    my_count = all_player_cards[current_player].length

    all_player_cards.each_with_index do |player_cards, i|
      points = 0 if i != current_player && player_cards.length >= my_count
    end

    inst.final_b = points
  end
  CardContainer.add_card(apex_predator)

  CardContainer.add_basic_card('APPEALING', :green, 'Classic', 3)
  CardContainer.add_basic_card('AUTOMIMICRY', :blue, 'Classic', 0)
end
