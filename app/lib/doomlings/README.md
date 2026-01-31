# Doomlings Scorer

Ruby implementation of a scoring system for the Doomlings card game.

**189 cards converted** from TypeScript | 14 tests passing ✅

## Usage

```ruby
# Create a scorer with player cards
scorer = Doomlings::Scorer.new(
  [{ name: 'ACROBATIC' }, { name: 'ADORABLE' }],  # Player 1
  [{ name: 'APEX PREDATOR' }]                      # Player 2
)

# Get scores
game_score = scorer.scores
game_score.get_player_score(0).total  # => 6
game_score.winning_player_indices     # => [0]

# Cards with metadata
scorer = Doomlings::Scorer.new(
  [{ name: 'ALTRUISTIC', gene_pool_size: 5 }]
)

# Add catastrophes
scorer.add_catastrophes([{ name: 'AI TAKEOVER' }])
```

## Running

```bash
# Examples
ruby lib/doomlings/example.rb

# Tests (14 tests, all passing)
bin/rails test test/lib/doomlings/scorer_test.rb
```

## Card Files

- `a_cards.rb` - ACROBATIC to AUTOMIMICRY (8 cards)
- `b_cards.rb` - BAD to BULLHEADED (13 cards)
- `c_cards.rb` - CAMOUFLAGE to CYBERNETIC (14 cards)
- `d_cards.rb` - DEEP ROOTS to DREAMER (9 cards)
- `e_cards.rb` - ECHOLOCATION to ENLIGHTENMENT (13 cards)
- `f_cards.rb` - FAITH to FULFILLED (14 cards)
- `g_cards.rb` - GALACTIC DRIFT to GREY HAT (8 cards)
- `h_cards.rb` - HAND-WING to HYPER-MYELINATION (8 cards)
- `i_cards.rb` - ICY to IRIDESCENT SCALES (7 cards)
- `j_k_cards.rb` - JUICY to KIDNEY (8 cards)
- `l_m_n_o_cards.rb` - LATE to OZMORIAN WINDS (26 cards)
- `p_q_r_cards.rb` - PACK BEHAVIOR to RUGGEDIZED (26 cards)
- `s_t_v_w_z_cards.rb` - SALIVA to ZOMBIFIED (49 cards)
- `catastrophe_cards.rb` - AI TAKEOVER, BIOENGINEERED PLAGUE (2 cards)
- `effect_cards.rb` - Helper for BOREDOM card

## Adding Cards

### Basic card
```ruby
CardContainer.add_basic_card('CARD NAME', :color, 'Pack Name', score)
```

### Complex card
```ruby
card = PlayerCard.new(name: 'CARD NAME', type: :red, pack: 'Classic')

card.define_singleton_method(:calc_a) do |inst, _all_cards, _player|
  inst.final_a = 5
end

card.define_singleton_method(:calc_b) do |inst, all_player_cards, current_player|
  inst.final_b = # your logic here
end

CardContainer.add_card(card)
```

## Scoring Phases

1. **calc_a** - Base score
2. **calc_b** - Trait-based bonuses
3. **calc_c** - Catastrophe effects

Converted from TypeScript: `/Users/davidhenry/dev/play/doomlings-scorer-typescript`
