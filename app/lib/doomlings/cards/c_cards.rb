# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  camouflage = PlayerCard.new(
    name: 'CAMOUFLAGE',
    type: :red,
    pack: 'Techlings',
    metadata_required: [[:cards_in_hand, :number]]
  )
  camouflage.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 2
  end
  camouflage.define_singleton_method(:calc_b) do |inst, _all_cards, _player|
    unless inst.metadata[:cards_in_hand].is_a?(Integer)
      raise 'invalid data for metadata field cards_in_hand'
    end

    inst.final_b = inst.metadata[:cards_in_hand]
  end
  CardContainer.add_card(camouflage)

  CardContainer.add_basic_card('CARNOSAUR JAW', :red, 'Dinolings', 9)
  CardContainer.add_basic_card('CERATOPSIAN HORNS', :green, 'Dinolings', 4)
  CardContainer.add_basic_card('CHROMATOPHORES', :blue, 'Classic', 0)
  CardContainer.add_basic_card('CLEVER', :purple, 'Classic', 1)
  CardContainer.add_basic_card('COASTAL FORMATIONS', :green, 'Classic', 0)
  CardContainer.add_basic_card('COLD BLOOD', :blue, 'Classic', 1)
  CardContainer.add_basic_card('COMET SHOWERS', :red, 'Classic', 0)
  CardContainer.add_basic_card('CONFUSION', :colourless, 'Classic', -2)
  CardContainer.add_basic_card('COSTLY SIGNALING', :blue, 'Classic', -2)

  cranial_crest = PlayerCard.new(
    name: 'CRANIAL CREST',
    type: :colourless,
    pack: 'Dinolings'
  )
  cranial_crest.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 4
  end
  cranial_crest.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    types = player_cards.flat_map { |c| c.type }
    # we minus one as we have at least one colourless that doesn't count
    inst.final_b = -(types.uniq.length - 1)
  end
  CardContainer.add_card(cranial_crest)

  CardContainer.add_basic_card('CURIOSITY', %i[blue red], 'multi-colour', 1)
  CardContainer.add_basic_card('CYBERNETIC', :blue, 'Techlings', 1)
end
