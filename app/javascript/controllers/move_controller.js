import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "moveForm" ]

  move({ detail: { from_key, to_key }}) {
    this.moveFormTarget.elements.from_key.value = from_key
    this.moveFormTarget.elements.to_key.value = to_key
    this.moveFormTarget.requestSubmit()
  }
}
