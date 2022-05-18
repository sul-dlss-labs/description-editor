import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    field: String,
    index: Number
  }

  static targets = [ "moveForm" ]

  dragstart(event) {
    event.dataTransfer.setData("text/plain", JSON.stringify({field: this.fieldValue, index: this.indexValue}))
    event.dataTransfer.effectAllowed = "move"
  }

  dragover(event) {
    event.preventDefault()
    return true
  }

  dragenter(event) {
      event.preventDefault()
  }

  drop(event) {
    event.preventDefault()
    const {field, index} = JSON.parse(event.dataTransfer.getData("text/plain"))
    if (field !== this.fieldValue) return
    if (this.indexValue === index) return
    this.moveFormTarget.elements.from_index.value = index
    this.moveFormTarget.requestSubmit()
  }
}
