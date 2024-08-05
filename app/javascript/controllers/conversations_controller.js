import { Controller } from "@hotwired/stimulus"
import ConversationsChannel from "../channels/conversations_channel";

// Connects to data-controller="conversations"
export default class extends Controller {
  static values = { currentUserId: Number }

  connect() {
    console.log("ConversationsStimulus=> connected")
    console.log(`ConversationsStimulus=> currentUserIdValue; ${this.currentUserIdValue}`)
    this.channel = ConversationsChannel.subscribe(this.currentUserIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`ConversationsStimulus=> unsubscribing from ConversationsChannel for currentUserId; ${this.currentUserIdValue}`);
      this.channel.unsubscribe();
    }
    console.log("ConversationsStimulus=> disconnecting");
  }
}
