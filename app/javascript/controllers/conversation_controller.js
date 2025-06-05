import { Controller } from "@hotwired/stimulus"
import { fetchEventSource } from "@microsoft/fetch-event-source"

// Connects to data-controller="conversation"
export default class extends Controller {
  static values = {
    completionUrl: String,
  }

  static targets = [ "form" ]

  connect() {
  }

  completion() {
    const formData = new FormData(this.formTarget)
    console.log("Sending form data:", formData)
    console.log("Completion URL:", this.completionUrlValue)
    fetchEventSource(this.completionUrlValue, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content"),
      }
    })
  }
}
