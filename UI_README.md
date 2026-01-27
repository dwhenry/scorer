# Doomlings Scorer UI

## Features

### Pack Selection
- Filter cards by pack type at the top of the page
- Default selection: Classic pack only
- Multiple packs can be selected simultaneously

### Player Management
- Select number of players (2-4) from the dropdown
- Each player has their own hand area
- Real-time score calculation as cards are added

### Catastrophe Cards
- Displayed at the top of the page with yellow background
- Click to toggle selection (active cards show a green checkmark)
- Apply globally to all players
- Affect final scoring

### Card Display
- Cards grouped by color (Colourless, Purple, Red, Green, Blue)
- Only cards from selected packs are shown
- Drag cards from the pack display to player hands
- Cards remain in pack display (can be used multiple times)

### Drag and Drop
- **Drag**: Click and hold on any card in the pack display
- **Drop**: Drag over a player's hand area and release
- Cards can appear multiple times in hands and pack

### Scoring
- **Live Updates**: Scores update automatically when cards are added/removed
- **Card Scores**: Each card shows its point contribution
- **Total Score**: Displayed prominently for each player
- **Score Details**: Hover over card scores to see breakdown (base + bonus)

### Card Management
- **Remove Card**: Click the × button on any card in a player's hand
- **Multiple Instances**: Same card can appear multiple times

## Usage

1. **Select Packs**: Choose which card packs to include
2. **Set Players**: Select number of players
3. **Add Catastrophes**: Click catastrophe cards to activate them
4. **Build Hands**: Drag cards from pack display to player hands
5. **View Scores**: Scores update automatically

## Keyboard Shortcuts
- None currently (drag and drop only)

## Technical Details
- Built with Rails 8 + Hotwire (Turbo + Stimulus)
- Real-time score calculation via backend API
- Responsive design for mobile and desktop
- Card images loaded from `/app/assets/images/cards/`

## Starting the Server

```bash
cd /Users/davidhenry/dev/play/scorer
bin/rails server
```

Then visit: `http://localhost:3000`
