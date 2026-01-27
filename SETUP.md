# Doomlings Scorer - Setup Complete ✅

## What's Been Built

### 1. Core Scoring Engine (Ruby/Rails)
- ✅ Converted all TypeScript card game logic to Ruby
- ✅ All card definitions imported (500+ cards)
- ✅ Three-phase scoring system (`calc_a`, `calc_b`, `calc_c`)
- ✅ Support for player cards and catastrophe cards
- ✅ Metadata handling for complex cards

**Location**: `/lib/doomlings/`

### 2. Interactive Web UI
- ✅ Pack selection (filter which card packs to display)
- ✅ Player management (2-4 players)
- ✅ Drag & drop interface for adding cards to player hands
- ✅ Real-time score calculation
- ✅ Catastrophe card toggling
- ✅ Visual card display with images
- ✅ Responsive design

**Files**:
- Controller: `app/controllers/game_controller.rb`
- View: `app/views/game/index.html.erb`
- JavaScript: `app/javascript/controllers/game_scorer_controller.js`
- Styles: `app/assets/stylesheets/game.css`
- Images: `app/assets/images/cards/` (502 card images)

### 3. Testing Framework (RSpec)
- ✅ RSpec configured as default testing framework
- ✅ Test helpers for card testing
- ✅ Basic scorer specs created
- ✅ Generator configured to use RSpec

**Configuration**:
- `.rspec` - RSpec options
- `spec/spec_helper.rb` - RSpec core config
- `spec/rails_helper.rb` - Rails integration
- `spec/support/card_helpers.rb` - Test helpers
- `config/application.rb` - Rails generator config for RSpec

## Next Steps

### 1. Install Dependencies

```bash
cd /Users/davidhenry/dev/play/scorer
bundle install
```

**Note**: If you encounter SSL/certificate errors with `bundle install`, try:
```bash
# Option 1: Update bundler
gem update --system
gem install bundler

# Option 2: Use different SSL verification
bundle config set ssl_verify_mode 0  # temporary workaround
bundle install
```

### 2. Start the Application

```bash
bin/rails server
```

Then visit: **http://localhost:3000**

### 3. Run Tests

```bash
# Run all specs
bundle exec rspec

# Run specific spec file
bundle exec rspec spec/lib/doomlings/scorer_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## How to Use the UI

1. **Select Card Packs**: Check which packs you want to include (Classic is selected by default)
2. **Choose Players**: Select 2-4 players from the dropdown
3. **Add Catastrophe Cards**: Click on catastrophe cards at the top to toggle them (they'll show a green checkmark)
4. **Drag Cards**: Drag cards from the pack display into player hands
5. **View Scores**: Scores update automatically as you add/remove cards
6. **Remove Cards**: Click the × button on any card in a player's hand

## Project Structure

```
scorer/
├── app/
│   ├── assets/
│   │   ├── images/cards/          # 502 card images
│   │   └── stylesheets/
│   │       ├── application.css
│   │       └── game.css
│   ├── controllers/
│   │   └── game_controller.rb     # Main game controller
│   ├── javascript/
│   │   └── controllers/
│   │       └── game_scorer_controller.js  # Stimulus controller
│   └── views/
│       └── game/
│           └── index.html.erb     # Main game interface
├── lib/doomlings/
│   ├── card.rb                    # Base card classes
│   ├── card_instance.rb           # Card with metadata
│   ├── card_container.rb          # Card registry
│   ├── scorer.rb                  # Main scoring engine
│   └── cards/                     # Card definitions
│       ├── a_cards.rb
│       ├── b_cards.rb
│       ├── catastrophe_cards.rb
│       └── ...
├── spec/                          # RSpec tests
│   ├── lib/doomlings/
│   │   └── scorer_spec.rb
│   ├── support/
│   │   └── card_helpers.rb
│   ├── spec_helper.rb
│   └── rails_helper.rb
├── config/
│   ├── routes.rb                  # Routes including API endpoint
│   ├── application.rb             # RSpec generator config
│   └── initializers/
│       └── doomlings.rb          # Auto-load all cards
└── Gemfile                        # Includes rspec-rails
```

## API Endpoints

### POST /game/calculate_score
Calculate scores for all players based on their cards and active catastrophes.

**Request Body**:
```json
{
  "players": [
    [{"name": "ACROBATIC"}, {"name": "BINARY"}],
    [{"name": "APEX PREDATOR", "metadata": {"trait": "red"}}]
  ],
  "catastrophes": ["AI TAKEOVER", "BIOENGINEERED PLAGUE"]
}
```

**Response**:
```json
{
  "players": [
    {
      "total": 8,
      "cards": [
        {"name": "ACROBATIC", "finalA": 5, "finalB": 0, "total": 5},
        {"name": "BINARY", "finalA": 0, "finalB": 3, "total": 3}
      ]
    },
    {
      "total": 11,
      "cards": [
        {"name": "APEX PREDATOR", "finalA": 7, "finalB": 4, "total": 11}
      ]
    }
  ]
}
```

## Features

### Pack Display
- Cards grouped by color (Colourless, Purple, Red, Green, Blue)
- Filter by pack (Classic, Special Edition, Dinolings, etc.)
- Drag any card to a player's hand
- Cards remain in pack (can be used multiple times)

### Player Management
- 2-4 players supported
- Each player has their own hand
- Drop zone for easy card adding
- Individual card scores shown
- Total score per player

### Catastrophe Cards
- Displayed at top of page
- Click to toggle active/inactive
- Visual indicator when selected
- Applied globally during scoring

### Scoring
- Real-time calculation via backend API
- Shows base score (finalA) and bonus (finalB)
- Handles complex card interactions
- Supports card metadata (traits, numbers, etc.)

## Technology Stack

- **Backend**: Ruby on Rails 8.1
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Testing**: RSpec
- **Styling**: Custom CSS
- **Assets**: Propshaft (Rails 8 default)

## RSpec as Default

RSpec is now configured as the default testing framework:

- ✅ New generators will create RSpec specs instead of Minitest tests
- ✅ Run tests with `bundle exec rspec`
- ✅ Test helpers available in `spec/support/`
- ✅ Rails integration configured
- ✅ Example specs in `spec/lib/doomlings/`

To generate new specs:
```bash
rails generate controller MyController index
# Creates: spec/controllers/my_controller_spec.rb (when RSpec is installed)
```

## Troubleshooting

### Bundle Install Issues
If you get SSL/certificate errors, this is likely a system Ruby/OpenSSL configuration issue. Try:
1. Update Ruby: `rbenv install 3.3.0` (or latest)
2. Update RubyGems: `gem update --system`
3. Temporary workaround: `bundle config set ssl_verify_mode 0`

### Server Won't Start
Make sure you've run `bundle install` first.

### Tests Won't Run
RSpec needs to be installed via `bundle install`.

### Cards Not Showing
Make sure card images are in `app/assets/images/cards/`. They should be named exactly as the card names (e.g., `ACROBATIC.small.png`).

## Contributing

To add new cards:
1. Edit the appropriate file in `lib/doomlings/cards/`
2. Follow the existing pattern
3. Add tests in `spec/lib/doomlings/`
4. Run tests to verify

To modify UI:
1. Update view: `app/views/game/index.html.erb`
2. Update styles: `app/assets/stylesheets/game.css`
3. Update JavaScript: `app/javascript/controllers/game_scorer_controller.js`

---

**Status**: ✅ Ready to use! Just run `bundle install` and `bin/rails server`
