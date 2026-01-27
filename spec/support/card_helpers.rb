# frozen_string_literal: true

module CardHelpers
  def zero_point_colourless_card
    { name: 'BINARY' }
  end

  def zero_point_blue_card
    { name: 'AUTOMIMICRY' }
  end

  def zero_point_green_card
    { name: 'COASTAL FORMATIONS' }
  end

  def zero_point_red_card
    { name: 'COMET SHOWERS' }
  end

  def zero_point_purple_card
    { name: 'ECLIPSE' }
  end
end

RSpec.configure do |config|
  config.include CardHelpers
end
