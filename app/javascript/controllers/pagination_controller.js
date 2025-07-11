import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

// Connects to data-controller="pagination"
export default class extends Controller {
  static values = {
    rootMargin: { type: String, default: "1000px" },
  }

  static targets = ["nextPageLink"]

  connect() {
    this.observer = new IntersectionObserver((entries) => {
      if (entries[0].isIntersecting) {
        this.observer.unobserve(this.nextPageLinkTarget)
        this.loadNextPage()
      }
    }, {
      rootMargin: this.rootMarginValue,
    })

    if (this.hasNextPageLinkTarget) {
      this.observer.observe(this.nextPageLinkTarget)
    }
  }

  disconnect() {
    this.observer.disconnect()
  }

  async loadNextPage() {
    const response = await get(this.nextPageLinkTarget.href)
    if (response.ok) {
      const html = await response.html
      const dom = new DOMParser().parseFromString(html, 'text/html')
      const newElement = dom.getElementById(this.element.id)
      if (newElement) {
        this.nextPageLinkTarget.outerHTML = newElement.innerHTML

        if (this.hasNextPageLinkTarget) {
          this.observer.observe(this.nextPageLinkTarget)
        }
      }
    }
  }
}
