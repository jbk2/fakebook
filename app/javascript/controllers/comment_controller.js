import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ "form" ]
  connect() { 
    this.formTarget.classList.add("hidden");
    console.log(`%cCommentStimulus=>%c connected\n
      comment FormTarget found; ${this.formTarget}`, "color: blue; font-weight: bold;", "");
  }

  toggle(event) {
    event.preventDefault();
    console.log("%cCommentStimulus=>%c toggle Comment form button clicked", "color: blue; font-weight: bold;", "");
    this.formTarget.classList.toggle("hidden");
  }

}