import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "conditionalInput", "checkInput" ]

  static values = {
    checkValue: String
  }

  connect() {
    this.enable({target: this.checkInputTarget})
  }

  enable(event) {    
    if(event.target.value === this.checkValueValue) {
      this.conditionalInputTarget.disabled = false
    } else {
      this.conditionalInputTarget.disabled = true
    }
  }  
}
