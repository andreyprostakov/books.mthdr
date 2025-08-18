import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "authorSelect",
    "titleInput",
    "goodreadsQueryLink",
    "oldValueViewTemplate",
    "tagAddButton",
    "tagBadges",
    "tagNewNameInput",
    "tagTemplate",
    "wikiQueryLink",
  ]

  connect() {
    this.syncGoodreadsQuery()

    this.syncWikiQuery()

    this.fillInitialTags()
    this.updateTagAddButton()
    this.initializeChangeIndicators()
  }

  //
  // GOODREADS
  //

  syncGoodreadsQuery() {
    const title = this.titleInputTarget.value.trim()
    const author = this.authorSelectTarget.selectedOptions[0]?.text.trim() || 'author'
    if (title) {
      const query = { q: `goodreads book ${title} by ${author}` }
      this.goodreadsQueryLinkTarget.href = `http://google.com/search?${new URLSearchParams(query)}`
    } else {
      this.goodreadsQueryLinkTarget.removeAttribute('href')
    }
  }

  //
  // WIKI
  //

  syncWikiQuery() {
    const title = this.titleInputTarget.value.trim()
    const author = this.authorSelectTarget.selectedOptions[0]?.text.trim() || 'author'
    if (title) {
      const query = { q: `wikipedia book ${title} by ${author}` }
      this.wikiQueryLinkTarget.href = `http://google.com/search?${new URLSearchParams(query)}`
    } else {
      this.wikiQueryLinkTarget.removeAttribute('href')
    }
  }

  //
  // TAGS
  //

  fillInitialTags() {
    const tagNames = JSON.parse(this.tagBadgesTarget.dataset.initialTags)
    const oldTagNames = JSON.parse(this.tagBadgesTarget.dataset.oldValue)
    tagNames.forEach(tagName => {
      this.addTag(tagName, { new: !oldTagNames.includes(tagName) })
    })
    oldTagNames.forEach(tagName => {
      if (tagNames.includes(tagName)) return

      const tagBadge = this.addTag(tagName)
      this.markTagAsRemoved(tagBadge)
    })
  }

  updateTagAddButton() {
    const tagName = this.tagNewNameInputTarget.value.trim()
    if (tagName) {
      this.tagAddButtonTarget.disabled = false
    } else {
      this.tagAddButtonTarget.disabled = true
    }
  }

  onTagAddClicked(event) {
    event.preventDefault()
    const tagName = this.tagNewNameInputTarget.value.trim()
    this.tagNewNameInputTarget.value = ''
    if (!tagName) return

    this.addTag(tagName, { new: true })
  }

  addTag(tagName, options = { new: false }) {
    const tagTemplate = this.tagTemplateTarget.content.cloneNode(true)
    tagTemplate.querySelector('[data-name="tagName"]').textContent = tagName
    tagTemplate.querySelector('[data-name="tagNameInput"]').value = tagName
    const tagBadge = tagTemplate.querySelector('[data-name="tagBadge"]')
    this.tagBadgesTarget.appendChild(tagTemplate)
    if (options.new) {
      tagBadge.classList.add('new')
      tagBadge.dataset.newTag = true
    }
    return tagBadge
  }

  deleteTag(event) {
    const tagBadge = event.target.closest('[data-name="tagBadge"]')
    if (!tagBadge) return

    if (tagBadge.dataset.newTag) {
      tagBadge.remove()
    } else {
      this.markTagAsRemoved(tagBadge)
    }
  }

  markTagAsRemoved(tagBadge) {
    tagBadge.classList.add('removed')
    tagBadge.querySelector('[data-name="tagNameInput"]').disabled = true
  }

  restoreTag(event) {
    const tagBadge = event.target.closest('[data-name="tagBadge"]')
    if (!tagBadge) return

    tagBadge.classList.remove('removed')
    tagBadge.querySelector('[data-name="tagNameInput"]').disabled = false
  }

  //
  // CHANGE INDICATORS
  //

  initializeChangeIndicators() {
    this.element.querySelectorAll('[data-behaviour="indicateChanges"]').forEach(element => {
      const presetOldValue = element.dataset.oldValue
      if (presetOldValue) {
        this.handleInpicatedChange(element)
      } else {
        element.dataset.oldValue = element.value.trim()
      }
      element.addEventListener('input', (event) => this.handleInpicatedChange.bind(this)(event.target))
    })
  }

  handleInpicatedChange(inputElement) {
    const currentValue = inputElement.value.trim()
    const oldValue = inputElement.dataset.oldValue

    if (currentValue !== oldValue) {
      this.showOldValue(inputElement, oldValue)
    } else {
      this.hideOldValue(inputElement)
    }
  }

  showOldValue(inputElement, oldValue) {
    var oldValueView = inputElement.parentElement.querySelector('[data-name="oldValueDisplay"]')
    if (!oldValueView) {
      oldValueView = this.oldValueViewTemplateTarget.content.cloneNode(true)
      var oldValueText = oldValue
      if (inputElement.type === 'select-one') {
        const option = Array.from(inputElement.options).find(opt => opt.value === oldValue)
        oldValueText = option ? option.text : oldValue
      }
      oldValueView.querySelector('[data-name="oldValue"]').textContent = oldValueText
      inputElement.parentElement.appendChild(oldValueView)
    }
  }

  hideOldValue(inputElement) {
    const oldValueView = inputElement.parentElement.querySelector('[data-name="oldValueDisplay"]')
    if (oldValueView) {
      oldValueView.remove()
    }
  }

  resetOldValue(event) {
    const inputElement = event.target.parentElement.parentElement.querySelector('[data-behaviour="indicateChanges"]')
    const oldValue = inputElement.dataset.oldValue.trim()
    inputElement.value = oldValue
    inputElement.dispatchEvent(new Event('input', { bubbles: true }))
  }
}
