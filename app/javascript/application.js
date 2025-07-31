// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

Turbo.StreamActions.message_chunk  = function () {
  this.targetElements.forEach((element) => {
    element.dataset.messageContentValue = (element.dataset.messageContentValue || "") + this.templateContent.textContent
  })
}
