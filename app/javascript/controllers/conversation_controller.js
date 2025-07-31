import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conversation"
export default class extends Controller {
  static values = {
  }

  static targets = [ "form", "messages" ]

  connect() {
  }
}
