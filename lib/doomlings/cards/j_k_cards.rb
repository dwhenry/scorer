# frozen_string_literal: true

require_relative '../card_container'

module Doomlings
  # J Cards - Note: Some cards missing scores in original TS (commented out)
  # CardContainer.add_basic_card('JOY', :colourless, 'KSE', ??)
  CardContainer.add_basic_card('JUICY', :purple, 'KSE', 2)
  CardContainer.add_basic_card('JUST', :colourless, 'Classic', 2)

  # K Cards
  CardContainer.add_basic_card('KIDNEY (1)', :red, 'Classic', 0)
  CardContainer.add_basic_card('KIDNEY (2)', :red, 'Classic', 0)
  CardContainer.add_basic_card('KIDNEY (3)', :red, 'Classic', 0)
  CardContainer.add_basic_card('KIDNEY (4)', :red, 'Classic', 0)
  CardContainer.add_basic_card('KIDNEY (5)', :red, 'Classic', 0)
end
