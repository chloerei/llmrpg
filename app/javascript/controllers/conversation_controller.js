import { Controller } from "@hotwired/stimulus"
import { fetchEventSource } from "@microsoft/fetch-event-source"

// Connects to data-controller="conversation"
export default class extends Controller {
  static values = {
    completionUrl: String,
  }

  static targets = [ "form", "messages" ]

  connect() {
  }

  completion() {
    const formData = new FormData(this.formTarget)
    this.formTarget.reset()
    fetchEventSource(this.completionUrlValue, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content"),
      },
      onmessage: (event) => {
        const data = JSON.parse(event.data)
        switch (data.action) {
          case "create":
            this.messagesTarget.insertAdjacentHTML("beforeend", data.message.html)
            break
          case "update":
            const updateMessageElement = document.getElementById(`message_${data.message.id}`)
            if (updateMessageElement) {
              updateMessageElement.outerHTML = data.message.html
            }
            break
          case "append":
            const appendMessageElement = document.getElementById(`message_${data.message.id}`)
            if (appendMessageElement) {
              appendMessageElement.dataset.messageContentValue = (appendMessageElement.dataset.messageContentValue || "") + data.message.content
            }
            break
          default:
        }
      },
      onclose: () => {
      },
      onerror: (error) => {
        throw error
      },
    })
  }
}
