import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.addEventListener("animationend", () => {
        this.element.remove()
      })

      this.element.classList.add("animate-fade-out")
    }, 5000)
  }
}
