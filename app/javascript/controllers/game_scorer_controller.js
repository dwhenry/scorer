import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["packFilter", "playerCount", "playersContainer", "catastropheContainer", "cardZoom", "cardZoomImage", "cardZoomName", "headerControls", "configToggle", "selectionHint"]

  connect() {
    this.players = []
    this.selectedCatastrophes = []
    this.selectedPlayerId = null
    this.images = {
      small: {},
      large: {}
    }

    // Build image lookup from rendered cards
    this.buildImageLookup()

    this.updatePlayerCount()
    this.adjustHeaderPadding()

    // Adjust padding on window resize
    window.addEventListener('resize', () => this.adjustHeaderPadding())
  }

  buildImageLookup() {
    // Scan all pack cards to build image URL lookup
    document.querySelectorAll('.pack-card').forEach(cardElement => {
      const cardName = cardElement.dataset.cardName
      const imgElement = cardElement.querySelector('img.small-card')
      const largeImgElement = cardElement.querySelector('img.large-card')

      if (cardName && imgElement && imgElement.src) {
        // Store small image URL
        this.images.small[cardName] = imgElement.src

        // Generate large image URL by replacing .small.png with .png
        this.images.large[cardName] = largeImgElement.src
      }
    })

    // Also scan catastrophe cards
    document.querySelectorAll('.catastrophe-card').forEach(cardElement => {
      const cardName = cardElement.dataset.cardName
      const imgElement = cardElement.querySelector('img')

      if (cardName && imgElement && imgElement.src) {
        this.images.small[cardName] = imgElement.src
        this.images.large[cardName] = imgElement.src.replace('.small.png', '.png')
      }
    })

    console.log(`Loaded ${Object.keys(this.images.small).length} card images`)
  }

  adjustHeaderPadding() {
    const header = document.querySelector('.game-header')
    const container = document.querySelector('.game-container')

    if (header && container) {
      // Wait for layout to settle
      setTimeout(() => {
        const headerHeight = header.offsetHeight
        container.style.paddingTop = `${headerHeight + 20}px`
      }, 100)
    }
  }

  toggleConfig() {
    this.headerControlsTarget.classList.toggle('show')

    // Update button text
    if (this.headerControlsTarget.classList.contains('show')) {
      this.configToggleTarget.textContent = '✕'
    } else {
      this.configToggleTarget.textContent = '⚙️'
    }

    // Adjust padding after toggle
    this.adjustHeaderPadding()
  }

  showZoom(event) {
    const cardName = event.currentTarget.dataset.cardName
    if (!cardName) return

    // Get large image from lookup
    const zoomSrc = this.images.large[cardName] || `/assets/cards/${cardName}.png`

    // Update zoom preview
    this.cardZoomImageTarget.src = zoomSrc
    this.cardZoomImageTarget.alt = cardName
    this.cardZoomNameTarget.textContent = cardName

    // Show zoom
    this.cardZoomTarget.classList.add('active')
  }

  hideZoom(event) {
    this.cardZoomTarget.classList.remove('active')
  }

  updatePlayerCount() {
    const count = parseInt(this.playerCountTarget.value)
    this.createPlayers(count)
  }

  createPlayers(count) {
    this.playersContainerTarget.innerHTML = ''
    this.players = []

    for (let i = 0; i < count; i++) {
      const player = {
        id: i,
        name: `Player ${i + 1}`,
        cards: []
      }
      this.players.push(player)

      const playerElement = this.createPlayerElement(player)
      this.playersContainerTarget.appendChild(playerElement)
    }

    // Adjust padding after players are created
    this.adjustHeaderPadding()
  }

  createPlayerElement(player) {
    const div = document.createElement('div')
    div.className = 'player'
    div.dataset.playerId = player.id

    div.innerHTML = `
      <div class="player-header" data-action="click->game-scorer#selectPlayer" data-player-id="${player.id}">
        <h3>${player.name}</h3>
        <div class="player-score">
          <span class="total-score">0</span> points
        </div>
      </div>
      <div class="player-hand"
           data-player-id="${player.id}"
           data-action="dragover->game-scorer#dragOver drop->game-scorer#drop">
        <div class="drop-zone">Drop cards here or click to select player</div>
      </div>
    `

    return div
  }

  selectPlayer(event) {
    const playerId = parseInt(event.currentTarget.dataset.playerId)

    // Toggle selection
    if (this.selectedPlayerId === playerId) {
      this.selectedPlayerId = null
    } else {
      this.selectedPlayerId = playerId
    }

    // Update visual state
    this.updatePlayerSelection()
  }

  updatePlayerSelection() {
    document.querySelectorAll('.player').forEach(playerElement => {
      const playerId = parseInt(playerElement.dataset.playerId)
      if (playerId === this.selectedPlayerId) {
        playerElement.classList.add('selected')
      } else {
        playerElement.classList.remove('selected')
      }
    })

    // Update pack display to show clickable state
    const packDisplay = document.querySelector('.pack-display')
    if (this.selectedPlayerId !== null) {
      packDisplay?.classList.add('player-selected')
      const playerName = this.players[this.selectedPlayerId]?.name || `Player ${this.selectedPlayerId + 1}`
      this.selectionHintTarget.textContent = `👆 Click on cards below to add them to ${playerName}`
      this.selectionHintTarget.style.display = 'block'
    } else {
      packDisplay?.classList.remove('player-selected')
      this.selectionHintTarget.style.display = 'none'
    }
  }

  filterByPack() {
    console.log('here')
    const selectedPacks = Array.from(this.packFilterTarget.options)
      .filter(option => option.selected)
      .map(option => option.value)
    // Show/hide cards based on selected packs
    document.querySelectorAll('.pack-card').forEach(card => {
      const cardPack = card.dataset.cardPack
      if (selectedPacks.includes(cardPack)) {
        card.classList.remove('card-hidden')
        card.classList.add('card-visible')
      } else {
        card.classList.remove('card-visible')
        card.classList.add('card-hidden')
      }
    })

    // Show/hide color groups if they have no visible cards
    document.querySelectorAll('.color-group').forEach(group => {
      const visibleCards = group.querySelectorAll('.pack-card.card-visible')
      if (visibleCards.length > 0) {
        group.classList.remove('card-hidden')
        group.classList.add('card-visible')
      } else {
        group.classList.remove('card-visible')
        group.classList.add('card-hidden')
      }
    })
  }

  toggleCatastrophe(event) {
    const card = event.currentTarget
    const cardName = card.dataset.cardName

    card.classList.toggle('selected')

    if (card.classList.contains('selected')) {
      this.selectedCatastrophes.push(cardName)
    } else {
      this.selectedCatastrophes = this.selectedCatastrophes.filter(name => name !== cardName)
    }

    this.calculateAllScores()
  }

  clickCard(event) {
    // Only add to player if one is selected
    if (this.selectedPlayerId === null) {
      return
    }

    const cardName = event.currentTarget.dataset.cardName
    this.addCardToPlayer(this.selectedPlayerId, cardName)
    this.calculateScore(this.selectedPlayerId)
  }

  dragStart(event) {
    const cardName = event.currentTarget.dataset.cardName
    event.dataTransfer.effectAllowed = 'copy'
    event.dataTransfer.setData('cardName', cardName)
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = 'copy'
  }

  drop(event) {
    event.preventDefault()
    const cardName = event.dataTransfer.getData('cardName')
    const playerId = parseInt(event.currentTarget.dataset.playerId)

    this.addCardToPlayer(playerId, cardName)
    this.calculateScore(playerId)
  }

  addCardToPlayer(playerId, cardName) {
    const player = this.players[playerId]
    player.cards.push({ name: cardName })

    this.renderPlayerHand(playerId)
  }

  renderPlayerHand(playerId) {
    const playerElement = document.querySelector(`[data-player-id="${playerId}"]`)
    const handElement = playerElement.querySelector('.player-hand')

    const player = this.players[playerId]

    if (player.cards.length === 0) {
      handElement.innerHTML = '<div class="drop-zone">Drop cards here or click to select player</div>'
      this.adjustHeaderPadding()
      return
    }

    // Group cards by name
    const cardGroups = {}
    player.cards.forEach((card, index) => {
      if (!cardGroups[card.name]) {
        cardGroups[card.name] = {
          name: card.name,
          indices: [],
          count: 0
        }
      }
      cardGroups[card.name].indices.push(index)
      cardGroups[card.name].count++
    })

    // Render grouped cards
    handElement.innerHTML = Object.values(cardGroups).map(group => {
      const imgSrc = this.images.small[group.name] || `/assets/cards/${group.name}.small.png`
      const firstIndex = group.indices[0]

      return `
        <div class="card player-card"
             data-card-indices="${group.indices.join(',')}"
             data-card-name="${group.name}"
             data-action="mouseenter->game-scorer#showZoom mouseleave->game-scorer#hideZoom">
          <img src="${imgSrc}"
               alt="${group.name}">
          ${group.count > 1 ? `<div class="card-count">${group.count}</div>` : ''}
          <div class="card-score" data-card-score="${firstIndex}">-</div>
          <button class="remove-card"
                  data-action="click->game-scorer#removeCard"
                  data-player-id="${playerId}"
                  data-card-name="${group.name}">×</button>
        </div>
      `
    }).join('')

    // Adjust padding after cards are rendered
    this.adjustHeaderPadding()
  }

  removeCard(event) {
    const playerId = parseInt(event.currentTarget.dataset.playerId)
    const cardName = event.currentTarget.dataset.cardName

    // Find and remove one instance of this card
    const player = this.players[playerId]
    const cardIndex = player.cards.findIndex(card => card.name === cardName)

    if (cardIndex !== -1) {
      player.cards.splice(cardIndex, 1)
      this.renderPlayerHand(playerId)
      this.calculateScore(playerId)
    }
  }

  async calculateScore(playerId) {
    try {
      const allPlayerCards = this.players.map(p => p.cards)

      // Call the backend to calculate scores
      const response = await fetch('/game/calculate_score', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          players: allPlayerCards,
          catastrophes: this.selectedCatastrophes
        })
      })

      const data = await response.json()
      this.updateScoreDisplay(data)
    } catch (error) {
      console.error('Error calculating score:', error)
    }
  }

  calculateAllScores() {
    if (this.players.length > 0) {
      this.calculateScore(0)
    }
  }

  updateScoreDisplay(scoreData) {
    scoreData.players.forEach((playerScore, playerIndex) => {
      const playerElement = document.querySelector(`[data-player-id="${playerIndex}"]`)
      if (!playerElement) return

      // Update total score
      const totalScoreElement = playerElement.querySelector('.total-score')
      totalScoreElement.textContent = playerScore.total

      // Group scores by card name to sum up duplicates
      const player = this.players[playerIndex]
      const scoresByCardName = {}

      playerScore.cards.forEach((cardScore, cardIndex) => {
        const cardName = player.cards[cardIndex]?.name
        if (!cardName) return

        if (!scoresByCardName[cardName]) {
          scoresByCardName[cardName] = {
            total: 0,
            count: 0,
            baseScores: [],
            bonusScores: []
          }
        }

        scoresByCardName[cardName].total += cardScore.total
        scoresByCardName[cardName].count++
        scoresByCardName[cardName].baseScores.push(cardScore.finalA)
        scoresByCardName[cardName].bonusScores.push(cardScore.finalB || 0)
      })

      // Update card score displays
      playerElement.querySelectorAll('.player-card').forEach(cardElement => {
        const cardName = cardElement.dataset.cardName
        const indices = cardElement.dataset.cardIndices.split(',').map(i => parseInt(i))
        const firstIndex = indices[0]

        const cardScoreElement = cardElement.querySelector(`[data-card-score="${firstIndex}"]`)
        if (cardScoreElement && scoresByCardName[cardName]) {
          const groupScore = scoresByCardName[cardName]
          cardScoreElement.textContent = `${groupScore.total} pts`

          // Build detailed tooltip
          const avgBase = (groupScore.baseScores.reduce((a, b) => a + b, 0) / groupScore.count).toFixed(1)
          const avgBonus = (groupScore.bonusScores.reduce((a, b) => a + b, 0) / groupScore.count).toFixed(1)
          cardScoreElement.title = `Total: ${groupScore.total} (${groupScore.count}x)\nAvg Base: ${avgBase}, Avg Bonus: ${avgBonus}`
        }
      })
    })
  }
}
