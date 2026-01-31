# frozen_string_literal: true

# Load all card definition files (ignored by Zeitwerk due to naming conventions)
Rails.application.config.after_initialize do
  Dir[Rails.root.join("app/lib/doomlings/cards/*.rb")].each do |file|
    require file
  end
end
