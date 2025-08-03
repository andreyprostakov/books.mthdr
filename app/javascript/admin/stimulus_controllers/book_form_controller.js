import { faWindows } from "@fortawesome/free-brands-svg-icons"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "titleInput",
    "goodreadsQueryLink",
    "goodreadsUrlInput",
    "goodreadsPreview",
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
  }

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
    this.addTag(tagName)
  }

  addTag(tagName) {
    const tagTemplate = this.tagTemplateTarget.content.cloneNode(true)
    tagTemplate.querySelector('[data-name="tagName"]').textContent = tagName
    tagTemplate.querySelector('[data-name="tagNameInput"]').value = tagName
    this.tagBadgesTarget.appendChild(tagTemplate)
  }

  deleteTag(event) {
    const tagBadge = event.target.closest('[data-name="tagBadge"]')
    if (tagBadge) {
      tagBadge.remove()
    }
  }
}
