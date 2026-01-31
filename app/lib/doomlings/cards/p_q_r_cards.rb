# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  # P Cards
  CardContainer.add_basic_card('PACK BEHAVIOR', :green, 'Classic', 3)
  CardContainer.add_basic_card('PAINTED SHELL', :blue, 'Classic', 1)
  CardContainer.add_basic_card('PARASITIC', :purple, 'Classic', -2)
  CardContainer.add_basic_card('PERSUASIVE', :purple, 'Classic', 1)
  CardContainer.add_basic_card('PHOTOSYNTHESIS', :green, 'Classic', 1)
  CardContainer.add_basic_card('PHREAKISH EYES', :red, 'Techlings', 2)
  CardContainer.add_basic_card('POISONOUS', :purple, 'Classic', 2)
  CardContainer.add_basic_card('POLLINATION', :green, 'Classic', 1)
  CardContainer.add_basic_card('PREPPER', :colourless, 'Classic', 2)
  CardContainer.add_basic_card('PRIDE', :red, 'KSE', 2)
  CardContainer.add_basic_card('PROPAGATION', :green, 'Classic', 1)
  # CardContainer.add_basic_card('PROSPERITY', :green, 'Classic', ??)
  CardContainer.add_basic_card('PROTOFEATHERS', :purple, 'Dinolings', -2)
  CardContainer.add_basic_card('PTEROSAUR WINGS', :blue, 'Dinolings', 1)
  # CardContainer.add_basic_card('PULSE EVENT', :purple, 'Classic', ??)
  CardContainer.add_basic_card('PYCNOFIBERS', :colourless, 'Dinolings', 1)

  # Q Cards
  CardContainer.add_basic_card('QUICK', :red, 'Classic', 2)

  # R Cards
  CardContainer.add_basic_card('RAINBOW HORN', :colourless, 'Mythlings', 2)
  CardContainer.add_basic_card('RANDOM FERTILIZATION', :green, 'Classic', 0)
  CardContainer.add_basic_card('RECKLESS', :red, 'Classic', 3)
  # CardContainer.add_basic_card('REFORESTATION', :green, 'Classic', ??)
  CardContainer.add_basic_card('REGENERATIVE TISSUE', :blue, 'Classic', 0)
  CardContainer.add_basic_card('RETRACTABLE CLAWS', :red, 'Classic', 5)
  # CardContainer.add_basic_card('RETROVIRUS', :purple, 'Classic', ??)
  CardContainer.add_basic_card('RIGHTEOUS', :blue, 'Mythlings', 1)
  CardContainer.add_basic_card('RUGGEDIZED', :colourless, 'Techlings', 4)
end
