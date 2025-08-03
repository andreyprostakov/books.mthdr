import { faWindows } from "@fortawesome/free-brands-svg-icons"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "titleInput",
    "goodreadsQueryLink",
    "goodreadsUrlInput",
    "goodreadsPreview",
    "oldValueViewTemplate",
    "tagAddButton",
    "tagBadges",
    "tagNewNameInput",
    "tagTemplate"
  ]

  connect() {
    this.syncGoodreadsQuery()
    this.syncGoodreadsUrl()
    this.fillInitialTags()
    this.updateTagAddButton()
    this.initializeChangeIndicators()
  }

  //
  // GOODREADS
  //

  syncGoodreadsQuery() {
    const title = this.titleInputTarget.value.trim()
    if (title) {
      const query = { q: `goodreads book ${title}` }
      this.goodreadsQueryLinkTarget.href = `http://google.com/search?${new URLSearchParams(query)}`
    } else {
      this.goodreadsQueryLinkTarget.removeAttribute('href')
    }
  }

  syncGoodreadsUrl() {
    const url = this.goodreadsUrlInputTarget.value.trim()
    if (url) {
      this.goodreadsPreviewTarget.href = url
    } else {
      this.goodreadsPreviewTarget.removeAttribute('href')
    }
  }

  //
  // TAGS
  //

  fillInitialTags() {
    const tagNames = JSON.parse(this.tagBadgesTarget.dataset.initialTags)
    tagNames.forEach(tagName => {
      this.addTag(tagName)
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
  }

  deleteTag(event) {
    const tagBadge = event.target.closest('[data-name="tagBadge"]')
    if (!tagBadge) return

    if (tagBadge.dataset.newTag) {
      tagBadge.remove()
    } else {
      tagBadge.classList.add('removed')
      tagBadge.querySelector('[data-name="tagNameInput"]').disabled = true
    }
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
