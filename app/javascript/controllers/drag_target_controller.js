import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    titleIndex: Number,
    key: String
  }

  static targets = [ "moveForm" ]

  dragover(event) {
    event.preventDefault()
    return true
  }

  dragenter(event) {
      event.preventDefault()
  }

  drop(event) {
    event.preventDefault()

    const {titleIndex, key} = JSON.parse(event.dataTransfer.getData("text/plain"))

    // if source key is nil, then move from source title index to target title index unless source title index = target title index    
    if (key == '' && titleIndex !== this.titleIndexValue && this.hasMoveFormTarget) {
      // This is a child form, so available as a target.
      this.moveFormTarget.elements.from_index.value = titleIndex
      this.moveFormTarget.requestSubmit()
      return
    }
    
    // if source key is not nil and source title index = target title index move and for the same section.
    if (key != '' && titleIndex === this.titleIndexValue && this.baseKey(key) === this.baseKey(this.keyValue)) {
      // Dispatch event to ancestor form
      this.dispatch("move", { detail : { from_key: key, to_key: this.keyValue }})
      return
    }
  }

  baseKey(key) {
    const split_key = key.split(/[\]\[]+/)
    return split_key.slice(0, split_key.length - 3 ).join('.')
  }
}
