import { Controller } from "@hotwired/stimulus"
import { options } from "marked"
import TomSelect from "tom-select"

// Connects to data-controller="character-select"
export default class extends Controller {
  static targets = ["input"]

  static values = {
    options: Array,
  }

  connect() {
    this.tomSelect = new TomSelect(this.inputTarget, {
      valueField: "id",
      searchField: "name",
      options: this.optionsValue,
      render: {
        option: (data, escape) => {
          return `
            <div>
              <div class="avatar">
                <div class="size-6 rounded-full">
                  <img src="${data.avatar_url}">
                </div>
              </div>
              <span>${escape(data.name)}</span>
            </div>
          `
        },
        item: (data, escape) => {
          return `
            <div title="${escape(data.name)}">
              <div class="avatar">
                <div class="size-6 rounded-full">
                  <img src="${data.avatar_url}">
                </div>
              </div>
              <span>${escape(data.name)}</span>
            </div>
          `
        }
      },
      plugins: {
        remove_button: {
          title: "Remove this character",
        },
      }
    })
  }
}
