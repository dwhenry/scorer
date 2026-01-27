# frozen_string_literal: true

module Doomlings
  # Cards that have no effect (used by BOREDOM card)
  EFFECTLESS_CARDS = [
    'ACROBATIC', 'ADORABLE', 'ANTLERS', 'APPEALING', 'BARK', 'BIG EARS', 'BLOOM', 'BLUBBER',
    'BONE REINFORCEMENT', 'BULLHEADED', 'CERATOPSIAN HORNS', 'CONFUSION', 'CURIOSITY', 'DEEP ROOTS',
    'DESTINED', 'DIAPHANOUS WINGS', 'FANGS', 'FEAR', 'FINE MOTOR SKILLS', 'FIRE SKIN', 'FLATULENCE',
    'GILLS', 'HAND-WING', 'ICY', 'LEAVES', 'MIGRATORY', 'MITOSIS', 'NOCTURNAL', 'QUICK', 'SAUDADE',
    'SPINY', 'STONE SKIN', 'TALONS', 'WOODY STEMS'
  ].freeze

  def self.has_effect?(card_name)
    !EFFECTLESS_CARDS.include?(card_name)
  end
end
