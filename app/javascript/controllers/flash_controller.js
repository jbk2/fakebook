import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    console.log("%cFlashStimulus=>%c connected", "color: blue; font-weight: bold;", "")
    setTimeout(() => {
      this.element.remove();
    }, 2500);
  }
}
