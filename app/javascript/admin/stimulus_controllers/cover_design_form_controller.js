import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'authorNameColorInput',
    'authorNameFontInput',
    'coverImageInput',
    'nameInput',
    'previewContainer',
    'previewTemplate',
    'titleColorInput',
    'titleFontInput',
  ]

  connect() {
    this.resetPreview()
  }

  resetPreview() {
    const canvas = this.previewTemplateTarget.content.cloneNode(true);

    canvas.querySelector('[data-name="container"]').classList.add(`b-cover-${this.coverImageInputTarget.value}`);

    const titleElement = canvas.querySelector('[data-name="title"]');
    titleElement.textContent = this.nameInputTarget.value;
    titleElement.classList.add(`b-text-color-${this.titleColorInputTarget.value}`);
    titleElement.classList.add(`b-font-${this.titleFontInputTarget.value}`);

    const authorElement = canvas.querySelector('[data-name="author"]');
    authorElement.classList.add(`b-text-color-${this.authorNameColorInputTarget.value}`);
    authorElement.classList.add(`b-font-${this.authorNameFontInputTarget.value}`);

    this.previewContainerTarget.innerHTML = null;
    this.previewContainerTarget.appendChild(canvas)
  }
}
