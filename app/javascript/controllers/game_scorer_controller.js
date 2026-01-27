import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["packFilter", "playerCount", "playersContainer", "catastropheContainer"]

  connect() {
    this.players = []
    this.selectedCatastrophes = []
    this.updatePlayerCount()
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
  }

  createPlayerElement(player) {
    const div = document.createElement('div')
    div.className = 'player'
    div.dataset.playerId = player.id

    div.innerHTML = `
      <div class="player-header">
        <h3>${player.name}</h3>
        <div class="player-score">
          <span class="total-score">0</span> points
        </div>
      </div>
      <div class="player-hand"
           data-player-id="${player.id}"
           data-action="dragover->game-scorer#dragOver drop->game-scorer#drop">
        <div class="drop-zone">Drop cards here</div>
      </div>
    `

    return div
  }

  filterByPack() {
    const selectedPacks = Array.from(this.packFilterTargets)
      .filter(checkbox => checkbox.checked)
      .map(checkbox => checkbox.value)

    // Show/hide cards based on selected packs
    document.querySelectorAll('.pack-card').forEach(card => {
      const cardPack = card.dataset.cardPack
      if (selectedPacks.includes(cardPack)) {
        card.style.display = 'block'
      } else {
        card.style.display = 'none'
      }
    })

    // Show/hide color groups if they have no visible cards
    document.querySelectorAll('.color-group').forEach(group => {
      const visibleCards = group.querySelectorAll('.pack-card[style="display: block"]')
      group.style.display = visibleCards.length > 0 ? 'block' : 'none'
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
      handElement.innerHTML = '<div class="drop-zone">Drop cards here</div>'
      return
    }

    handElement.innerHTML = player.cards.map((card, index) => `
      <div class="card player-card" data-card-index="${index}">
        <img src="/assets/cards/${card.name}.small.png"
             alt="${card.name}"
             onerror="this.src='/assets/card-placeholder.png'">
        <div class="card-name">${card.name}</div>
        <div class="card-score" data-card-score="${index}">-</div>
        <button class="remove-card"
                data-action="click->game-scorer#removeCard"
                data-player-id="${playerId}"
                data-card-index="${index}">×</button>
      </div>
    `).join('')
  }

  removeCard(event) {
    const playerId = parseInt(event.currentTarget.dataset.playerId)
    const cardIndex = parseInt(event.currentTarget.dataset.cardIndex)

    this.players[playerId].cards.splice(cardIndex, 1)
    this.renderPlayerHand(playerId)
    this.calculateScore(playerId)
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
    scoreData.players.forEach((playerScore, index) => {
      const playerElement = document.querySelector(`[data-player-id="${index}"]`)
      if (!playerElement) return

      // Update total score
      const totalScoreElement = playerElement.querySelector('.total-score')
      totalScoreElement.textContent = playerScore.total

      // Update individual card scores
      playerScore.cards.forEach((cardScore, cardIndex) => {
        const cardScoreElement = playerElement.querySelector(`[data-card-score="${cardIndex}"]`)
        if (cardScoreElement) {
          cardScoreElement.textContent = `${cardScore.total} pts`
          cardScoreElement.title = `Base: ${cardScore.finalA}, Bonus: ${cardScore.finalB || 0}`
        }
      })
    })
  }
}
