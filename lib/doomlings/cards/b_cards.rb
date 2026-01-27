# frozen_string_literal: true

require_relative '../card_container'
require_relative 'effect_cards'

module Doomlings
  CardContainer.add_basic_card('BAD', :red, 'Classic', 1)
  CardContainer.add_basic_card('BARK', :green, 'Classic', 2)
  CardContainer.add_basic_card('BEAUTY', :green, 'Classic', 2)
  CardContainer.add_basic_card('BIG EARS', :green, 'Classic', 2)
  CardContainer.add_basic_card('BINARY', :colourless, 'Techlings', 0)

  bionic_arm = PlayerCard.new(
    name: 'BIONIC ARM',
    type: :red,
    pack: 'Techlings'
  )
  bionic_arm.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = -1
  end
  bionic_arm.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    techling_cards = player_cards.select { |c| c.card.pack == 'Techlings' }

    # TODO: work out when this is attached and set to 2 when it is
    multiplier = 1

    inst.final_b = techling_cards.length * multiplier
  end
  CardContainer.add_card(bionic_arm)

  CardContainer.add_basic_card('BLOOM', %i[green blue], 'Classic', 1)
  CardContainer.add_basic_card('BLUBBER', :blue, 'Classic', 4)
  CardContainer.add_basic_card('BONE REINFORCEMENT', :red, 'Techlings', 4)
  CardContainer.add_basic_card('BONES', :colourless, 'Classic', 2)
  CardContainer.add_basic_card('BONY PLATES', :green, 'Dinolings', 2)

  # TODO: Cards in hand is **not** played cards. This is buggy.
  boredom = PlayerCard.new(
    name: 'BOREDOM',
    type: :colourless,
    pack: 'Classic'
  )
  boredom.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 0
  end
  boredom.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    player_cards = all_player_cards[current_player]
    effect_cards = player_cards.select do |card|
      Doomlings.has_effect?(card.card.name)
    end

    inst.final_b = effect_cards.length
  end
  CardContainer.add_card(boredom)

  branches = PlayerCard.new(
    name: 'BRANCHES',
    type: :green,
    pack: 'Classic'
  )
  branches.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
    inst.final_a = 0
  end
  branches.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
    points = 0

    # point for each pair of green cards in each player's hand
    all_player_cards.each_with_index do |player_cards, index|
      if index != current_player
        green_count = player_cards.count { |c| c.type.include?(:green) }
        points += green_count / 2
      end
    end

    inst.final_b = points
  end
  CardContainer.add_card(branches)

  CardContainer.add_basic_card('BRAVE', :red, 'Classic', 2)
  CardContainer.add_basic_card('BRUTE STRENGTH', :red, 'Classic', 4)
  CardContainer.add_basic_card('BULLHEADED', %i[red green], 'Classic', 1)
end
