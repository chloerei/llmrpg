import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="message"
export default class extends Controller {
  static values = {
    status: String,
    completionUrl: String
  }

  static targets = [ "content" ]

  connect() {
    if (this.statusValue == "pending") {
      this.requestCompletion()
    }
  }

  requestCompletion() {
    const eventSource = new EventSource(
      this.completionUrlValue
    )

    let content = ""

    eventSource.onmessage = (event) => {
      console.log("Received message:", event.data)
      const data = JSON.parse(event.data)
      content += data.content
      this.contentTarget.textContent = content

      if (data.done) {
        eventSource.close()
        console.log("EventSource closed")
      }
    }
  }
}
