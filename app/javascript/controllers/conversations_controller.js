import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conversations"
export default class extends Controller {
  // static values = { id: Number, idType: String }

  connect() {
    console.log("conversations Stimulus controller is now connected");
  }

   toggleConversationCard() {

    // Call the rails conversations controller show action, passing in the conversation-id
    // have the server action turbo render the conversation card?

    console.log("toggleConversationCard action called");
    const event = new CustomEvent('toggle-conversation-card', {
      detail: {
        id: this.idValue,
        idType: this.idTypeValue
      },
      bubbles: true
    });
    window.dispatchEvent(event);
  }
}
