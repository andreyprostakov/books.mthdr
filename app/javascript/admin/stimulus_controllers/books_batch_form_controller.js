import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'booksList',
    'bookTemplate'
  ]

  removeBook(event) {
    const bookRow = event.target.closest('[data-name="book-row"]')
    bookRow.remove()
  }

  onClickAddBook(event) {
    event.preventDefault()
    const booksList = this.booksListTarget
    const bookTemplate = this.bookTemplateTarget
    const newBook = bookTemplate.content.cloneNode(true)
    const tempWorkbench = document.createElement('div')
    tempWorkbench.appendChild(newBook)
    const index = Date.now()
    tempWorkbench.innerHTML = tempWorkbench.innerHTML.replaceAll('ENTRY_INDEX', index)
    booksList.appendChild(tempWorkbench.firstElementChild)
  }
}
