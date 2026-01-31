// Multiselect - Vanilla JS ES Module
// Converted from jQuery plugin by @conmarap

class Multiselect {
  constructor(element) {
    if (!element) {
      console.error("ERROR: Element does not exist.")
      return
    }

    this.element = element
    this.selections = []
    this.wrapper = null

    this.init()
    this.bindEvents()
  }

  init() {
    // Hide the original select
    this.element.style.display = 'none'

    // Create wrapper structure
    this.wrapper = document.createElement('div')
    this.wrapper.className = 'multiselect'
    this.wrapper.dataset.target = this.element.id || ''

    // Create title section
    const title = document.createElement('div')
    title.className = 'title'

    const text = document.createElement('span')
    text.className = 'text'
    text.textContent = 'Select'

    const closeIcon = document.createElement('span')
    closeIcon.className = 'close-icon'
    closeIcon.innerHTML = '&times;'

    const expandIcon = document.createElement('span')
    expandIcon.className = 'expand-icon'
    expandIcon.textContent = '▼'

    title.appendChild(text)
    title.appendChild(closeIcon)
    title.appendChild(expandIcon)

    // Create options container
    const optionsContainer = document.createElement('div')
    optionsContainer.className = 'options'

    // Copy options from original select
    Array.from(this.element.options).forEach(opt => {
      const option = document.createElement('div')
      option.className = 'option'
      option.dataset.value = opt.value
      option.textContent = opt.textContent
      optionsContainer.appendChild(option)
    })

    this.wrapper.appendChild(title)
    this.wrapper.appendChild(optionsContainer)

    // Insert wrapper after original select
    this.element.parentNode.insertBefore(this.wrapper, this.element.nextSibling)

    // Pre-select any already selected options
    Array.from(this.element.selectedOptions).forEach(opt => {
      this.selections.push(opt.value)
    })
    this.updateDisplay()
  }

  bindEvents() {
    const title = this.wrapper.querySelector('.title')
    const closeIcon = this.wrapper.querySelector('.close-icon')
    const options = this.wrapper.querySelectorAll('.option')

    // Toggle dropdown on title click
    title.addEventListener('click', (e) => {
      if (!e.target.classList.contains('close-icon')) {
        this.toggle()
      }
    })

    // Clear selections on close icon click
    closeIcon.addEventListener('click', (e) => {
      e.stopPropagation()
      this.clearSelections()
    })

    // Handle option selection
    options.forEach(option => {
      option.addEventListener('click', (e) => {
        e.stopPropagation()
        const value = option.dataset.value
        this.toggleSelection(value)
      })
    })

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
      if (!this.wrapper.contains(e.target)) {
        this.close()
      }
    })
  }

  toggle() {
    this.wrapper.classList.toggle('active')
  }

  open() {
    this.wrapper.classList.add('active')
  }

  close() {
    this.wrapper.classList.remove('active')
  }

  toggleSelection(value) {
    const index = this.selections.indexOf(value)

    if (index === -1) {
      this.selections.push(value)
    } else {
      this.selections.splice(index, 1)
    }

    this.updateDisplay()
    this.syncToSelect()
    this.dispatchChangeEvent()
  }

  updateDisplay() {
    const text = this.wrapper.querySelector('.text')
    const options = this.wrapper.querySelectorAll('.option')

    // Update selection class on wrapper
    if (this.selections.length > 0) {
      this.wrapper.classList.add('selection')
    } else {
      this.wrapper.classList.remove('selection')
    }

    // Update text display
    if (this.selections.length === 0) {
      text.textContent = 'Select'
      text.title = ''
    } else if (this.selections.length > 2) {
      const displaySelections = this.selections.slice(0, 2)
      text.textContent = displaySelections.join(', ') + ' [+ ' + (this.selections.length - 2) + 'more]'
      text.title = this.selections.join(', ')
    } else {
      text.textContent = this.selections.join(', ')
      text.title = this.selections.join(', ')
    }

    // Update selected state on options
    options.forEach(option => {
      if (this.selections.includes(option.dataset.value)) {
        option.classList.add('selected')
      } else {
        option.classList.remove('selected')
      }
    })
  }

  syncToSelect() {
    // Sync selections back to the original select element
    Array.from(this.element.options).forEach(opt => {
      opt.selected = this.selections.includes(opt.value)
    })
  }

  dispatchChangeEvent() {
    // Dispatch change event on original select
    const event = new Event('change', { bubbles: true })
    this.element.dispatchEvent(event)
  }

  clearSelections() {
    this.selections = []
    this.updateDisplay()
    this.syncToSelect()
    this.dispatchChangeEvent()
  }

  getSelections() {
    return this.selections
  }

  setSelections(arr) {
    if (!Array.isArray(arr)) {
      console.error("ERROR: This does not look like an array.")
      return
    }

    this.selections = arr
    this.updateDisplay()
    this.syncToSelect()
  }
}

// Auto-initialize on DOM ready and after Turbo navigation
function initMultiselects() {
  document.querySelectorAll('select.multiselect').forEach(select => {
    // Don't re-initialize if already done
    if (!select.dataset.multiselectInitialized) {
      select.dataset.multiselectInitialized = 'true'
      new Multiselect(select)
    }
  })
}

// Initialize on DOMContentLoaded
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initMultiselects)
} else {
  initMultiselects()
}

// Re-initialize after Turbo navigations
document.addEventListener('turbo:load', initMultiselects)
document.addEventListener('turbo:frame-load', initMultiselects)

export { Multiselect }
export default Multiselect
