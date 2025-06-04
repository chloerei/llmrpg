import { Controller } from "@hotwired/stimulus"
import { marked } from "marked"
import DOMPurify from "dompurify"

// Connects to data-controller="message"
export default class extends Controller {
  static values = {
    status: String,
    content: String,
  }

  static targets = [ "content" ]

  connect() {
    this.renderContent()
  }

  renderContent() {
    if (this.contentValue.length > 0) {
      const htmlContent = marked.parse(this.contentValue)
      this.contentTarget.innerHTML = DOMPurify.sanitize(htmlContent)
    }
  }

  contentValueChanged() {
    this.renderContent()
  }
}
