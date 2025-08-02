import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "fullnameInput",
    "referenceQueryLink", "referenceInput", "referenceLink",
    "photoQueryLink", "photoUrlInput", "photoPreview"
  ]

  connect() {
    this.syncName()
    this.syncReference()
    this.syncPhotoUrl()
  }

  syncName() {
    const fullname = this.fullnameInputTarget.value.trim()
    this.updateReferenceQuery(fullname)
    this.updatePhotoQuery(fullname)
  }

  syncReference() {
    const referenceUrl = this.referenceInputTarget.value.trim()
    if (referenceUrl) {
      this.referenceLinkTarget.setAttribute('href', referenceUrl)
    } else {
      this.referenceLinkTarget.removeAttribute('href')
    }
  }

  syncPhotoUrl() {
    const photoUrl = this.photoUrlInputTarget.value.trim()
    if (photoUrl) {
      this.photoPreviewTarget.setAttribute('href', photoUrl)
    } else {
      this.photoPreviewTarget.removeAttribute('href')
    }
  }

  updateReferenceQuery(fullname) {
    if (fullname) {
      var href = this.referenceQueryLinkTarget.getAttribute('data-href-scaffold')
      var queryUrl = href.replace('NAME', encodeURI(fullname))
      this.referenceQueryLinkTarget.setAttribute('href', queryUrl)
    } else {
      this.referenceQueryLinkTarget.removeAttribute('href')
    }
  }

  updatePhotoQuery(fullname) {
    if (fullname) {
      var href = this.photoQueryLinkTarget.getAttribute('data-href-scaffold')
      var queryUrl = href.replace('NAME', encodeURI(fullname))
      this.photoQueryLinkTarget.setAttribute('href', queryUrl)
    } else {
      this.photoQueryLinkTarget.removeAttribute('href')
    }
  }
}
