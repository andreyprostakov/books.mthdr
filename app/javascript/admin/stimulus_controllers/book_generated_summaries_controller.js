import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  onPick(event) {
    this.dispatch('pickSummary', { detail: event.params })
  }

  onAddAllTags(event) {
    this.dispatch('addTags', { detail: event.params })
  }
}
