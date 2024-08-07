import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {

  static targets = [ "source" ]

  connect() {
    console.log("%cClipboardStimulus =>%c connected", "color: blue; font-weight: bold;", "")
  }

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.textContent)
  }
}
