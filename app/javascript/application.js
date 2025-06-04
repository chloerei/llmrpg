// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

Turbo.StreamActions.message_append  = function () {
  this.targetElements.forEach((element) => {
    element.dataset.messageContentValue = (element.dataset.messageContentValue || "") + this.templateContent.textContent
  })
}
