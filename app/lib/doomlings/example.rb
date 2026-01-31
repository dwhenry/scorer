# frozen_string_literal: true

# Example usage of the Doomlings Scorer
require_relative 'scorer'
require_relative 'cards/a_cards'
require_relative 'cards/catastrophe_cards'

# Example 1: Simple game with basic cards
puts "=== Example 1: Simple Game ==="
scorer = Doomlings::Scorer.new(
  [{ name: 'ACROBATIC' }, { name: 'ADORABLE' }],  # Player 1
  [{ name: 'APEX PREDATOR' }, { name: 'ACROBATIC' }],  # Player 2
  [{ name: 'APPEALING' }]  # Player 3
)

game_score = scorer.scores

# Display scores
(0..2).each do |player_index|
  player_score = game_score.get_player_score(player_index)
  puts "Player #{player_index + 1} Total: #{player_score.total}"

  player_score.cards.each_with_index do |card, index|
    puts "  Card #{index + 1}: #{card.total} pts (Base: #{card.final_a}, Bonus: #{card.final_b})"
  end
end

puts "Winner(s): Player #{game_score.winning_player_indices.map { |i| i + 1 }.join(', ')}"
puts

# Example 2: Game with metadata cards
puts "=== Example 2: Cards with Metadata ==="
scorer2 = Doomlings::Scorer.new(
  [{ name: 'ALTRUISTIC', gene_pool_size: 7 }, { name: 'ACROBATIC' }],
  [{ name: 'ADORABLE' }, { name: 'ANTLERS' }]
)

game_score2 = scorer2.scores

(0..1).each do |player_index|
  player_score = game_score2.get_player_score(player_index)
  puts "Player #{player_index + 1} Total: #{player_score.total}"
end

puts "Winner(s): Player #{game_score2.winning_player_indices.map { |i| i + 1 }.join(', ')}"
puts

# Example 3: Game with catastrophe cards
puts "=== Example 3: With Catastrophe Card ==="
scorer3 = Doomlings::Scorer.new(
  [{ name: 'ALTRUISTIC', gene_pool_size: 10 }, { name: 'ACROBATIC' }],
  [{ name: 'ADORABLE' }, { name: 'ALTRUISTIC', gene_pool_size: 8 }]
).add_catastrophes([
  { name: 'AI TAKEOVER' }  # All colourless cards become 2 points
])

game_score3 = scorer3.scores

(0..1).each do |player_index|
  player_score = game_score3.get_player_score(player_index)
  puts "Player #{player_index + 1} Total: #{player_score.total}"

  player_score.cards.each_with_index do |card, index|
    puts "  Card #{index + 1}: #{card.total} pts (Base: #{card.final_a}, Bonus: #{card.final_b})"
  end
end

puts "Winner(s): Player #{game_score3.winning_player_indices.map { |i| i + 1 }.join(', ')}"
puts

# Example 4: Game with card removal catastrophe
puts "=== Example 4: With Card Removal Catastrophe ==="
scorer4 = Doomlings::Scorer.new(
  [{ name: 'ACROBATIC' }, { name: 'ADORABLE' }, { name: 'APPEALING' }],
  [{ name: 'ADORABLE' }, { name: 'ACROBATIC' }]
).add_catastrophes([
  { name: 'BIOENGINEERED PLAGUE', discard: ['ACROBATIC', 'ADORABLE'] }
])

game_score4 = scorer4.scores

(0..1).each do |player_index|
  player_score = game_score4.get_player_score(player_index)
  puts "Player #{player_index + 1} Total: #{player_score.total} (#{player_score.cards.length} cards remaining)"
end

puts "Winner(s): Player #{game_score4.winning_player_indices.map { |i| i + 1 }.join(', ')}"
