# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  CardContainer.add_basic_card('HAND-WING', %i[red purple], 'multi-colour', 1)

  heat_vision = PlayerCard.new(
    name: 'HEAT VISION',
    type: :red,
    pack: 'Classic'
  )
  heat_vision.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = -1
  end
  heat_vision.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    red_cards = all_player_cards[current_player].select do |card|
      card.card.type.include?(:red)
    end
    inst.final_b = red_cards.length
  end
  CardContainer.add_card(heat_vision)

  CardContainer.add_basic_card('HEROIC', :green, 'Classic', 7)
  CardContainer.add_basic_card('HIGH TIDES', :blue, 'Classic', 0)
  CardContainer.add_basic_card('HOT TEMPER', :red, 'Classic', 2)
  CardContainer.add_basic_card('HYPER-INTELLIGENCE', :red, 'Classic', 4)

  hyper_myelination = PlayerCard.new(
    name: 'HYPER-MYELINATION',
    type: :purple,
    pack: 'Techlings',
    metadata_required: [[:biggest_gene_pool_size, :number]]
  )
  hyper_myelination.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 0
  end
  hyper_myelination.define_singleton_method(:calc_b) do |inst, _all_cards, _player|
    unless inst.metadata[:biggest_gene_pool_size].is_a?(Integer)
      raise 'invalid data for metadata field gene_pool_size'
    end

    inst.final_b = inst.metadata[:biggest_gene_pool_size]
  end
  CardContainer.add_card(hyper_myelination)
end
