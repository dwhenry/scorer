# frozen_string_literal: true

# Load all Doomlings card definitions
Rails.application.config.to_prepare do
  # Load card definitions
  Dir[Rails.root.join('app/lib/doomlings/cards/*.rb')].sort.each do |file|
    require file
  end
end
