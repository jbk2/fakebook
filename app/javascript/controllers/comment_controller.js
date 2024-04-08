import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = [ "form" ]
  connect() { 
    console.log("comment_controller Stimulus controller is now connected");
    console.log("comment form taget found", this.formTarget)
  }

  toggle(event) {
    event.preventDefault();
    console.log("toggle button clicked");
    this.formTarget.classList.toggle("hidden");
  }

}