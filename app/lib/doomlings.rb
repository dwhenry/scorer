module Doomlings
  TRAIT_CARD_TYPES = %i[colourless purple red green blue].freeze
  CATASTROPHE_CARD_TYPES = %i[catastrophe].freeze
  OTHER_CARD_TYPES = %i[none].freeze
  CARD_TYPES = (TRAIT_CARD_TYPES + CATASTROPHE_CARD_TYPES + OTHER_CARD_TYPES).freeze

  PACK_TYPES = [
    'Classic',
    'Special Edition',
    'multi-colour',
    'Dinolings',
    'Mythlings',
    'Techlings',
    'Meaning of Life',
    'Overlush'
  ].freeze

  METADATA_TYPES = %i[number trait card_type card_per_person].freeze
end