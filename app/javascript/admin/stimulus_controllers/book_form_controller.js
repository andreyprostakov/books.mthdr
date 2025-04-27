import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "titleInput",
    "goodreadsQueryLink",
    "goodreadsUrlInput",
    "goodreadsPreview"
  ]

  connect() {
    this.syncGoodreadsQuery()
    this.syncGoodreadsUrl()
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
}