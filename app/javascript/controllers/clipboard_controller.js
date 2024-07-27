import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {

  static targets = [ "source" ]

  connect() {
    console.log("Connected to clipboard controller")
    console.log(`Source target is found ${this.sourceTarget.textContent}`);
  }

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.textContent)
  }
}
