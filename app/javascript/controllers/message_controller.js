import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {

  static targets = [ "messageCard" ]
  
  connect() {
    this.messageCardTarget.classList.add("hidden");
    console.log("message_controller Stimulus controller is now connected");
    console.log("messageCard taget found", this.messageCardTarget)

  }

  toggleMessageCard(event) {
    event.preventDefault();
    console.log("toggleMessageCard button clicked");
    this.messageCardTarget.classList.toggle("hidden");
  }
}