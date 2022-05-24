import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    titleIndex: Number,
    key: String
  }

  static targets = [ "moveForm" ]

  dragstart(event) {
    event.dataTransfer.setData("text/plain", JSON.stringify({key: this.keyValue, titleIndex: this.titleIndexValue}))
    event.dataTransfer.effectAllowed = "move"
  }

}
