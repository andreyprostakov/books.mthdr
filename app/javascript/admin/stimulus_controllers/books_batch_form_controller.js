import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
  ]

  removeBook(event) {
    const bookRow = event.target.closest('[data-name="book-row"]')
    bookRow.remove()
  }
}
