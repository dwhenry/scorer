# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  # L Cards
  CardContainer.add_basic_card('LATE', :colourless, 'Classic', 1)
  CardContainer.add_basic_card('LEAVES', :green, 'Classic', 1)
  CardContainer.add_basic_card('LEGENDARY', :blue, 'Mythlings', 8)
  # CardContainer.add_basic_card('LUNAR RETREAT', :blue, 'Classic', ??)
  CardContainer.add_basic_card('LYONIZATION', :green, 'Techlings', 1)

  # M Cards
  # CardContainer.add_basic_card('MASS EXTINCTION', :colourless, 'Classic', ??)
  CardContainer.add_basic_card('MECHA', :blue, 'Techlings', 2)
  # CardContainer.add_basic_card('MEGA TSUNAMI', :blue, 'Classic', ??)
  CardContainer.add_basic_card('MEMORY', :purple, 'Classic', 2)
  CardContainer.add_basic_card('MIGHTY', :red, 'Mythlings', 2)
  CardContainer.add_basic_card('MIGRATORY', :blue, 'Classic', 2)
  CardContainer.add_basic_card('MINDFUL', :colourless, 'Classic', 0)
  CardContainer.add_basic_card('MITOCHONDRION', :colourless, 'Classic', 1)
  CardContainer.add_basic_card('MITOSIS', :multi_colour, 'multi-colour', 1)
  CardContainer.add_basic_card('MORALITY', :colourless, 'Classic', 5)
  CardContainer.add_basic_card('MOTLEY', :multi_colour, 'multi-colour', 4)

  # N Cards
  CardContainer.add_basic_card('NANO', :green, 'Techlings', 0)
  # CardContainer.add_basic_card('NATURAL HARMONY', :green, 'Classic', ??)
  CardContainer.add_basic_card('NECROMANTIC', :purple, 'Mythlings', 1)
  CardContainer.add_basic_card('NEURAL LINK', :blue, 'Techlings', 2)
  CardContainer.add_basic_card('NOCTURNAL', :purple, 'Classic', 3)
  # CardContainer.add_basic_card('NORTHERN WINDS', :blue, 'Classic', ??)
  CardContainer.add_basic_card('NOSY', :purple, 'Classic', 1)
  # CardContainer.add_basic_card('NUCLEAR WINTER', :red, 'Classic', ??)

  # O Cards
  CardContainer.add_basic_card('OPTIMISTIC NIHILISM', :colourless, 'Classic', 4)
  CardContainer.add_basic_card('ORCISH TUSKS', :green, 'Mythlings', 1)
  CardContainer.add_basic_card('OVERGROWTH', :green, 'Classic', -1)
  # CardContainer.add_basic_card('OVERPOPULATION', :green, 'Classic', ??)
  # CardContainer.add_basic_card('OZMORIAN WINDS', :red, 'Mythlings', ??)
end
