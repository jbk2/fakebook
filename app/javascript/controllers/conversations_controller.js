import { Controller } from "@hotwired/stimulus"
import ConversationsChannel from "../channels/conversations_channel";

// Connects to data-controller="conversations"
export default class extends Controller {
  static values = { currentUserId: Number }

  connect() {
    console.log(`%cConversationsStimulus=>%c connected!`, "color: blue; font-weight: bold;", "");
    console.log(`currentUserIdValue; ${this.currentUserIdValue}`);
    this.channel = ConversationsChannel.subscribe(this.currentUserIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`%cConversationsStimulus=>%c unsubscribing from ConversationsChannel for currentUserId; ${this.currentUserIdValue}`, "color: blue; font-weight: bold;", "");
      this.channel.unsubscribe();
    }
    console.log("%cConversationsStimulus=>%c disconnecting", "color: blue; font-weight: bold;", "");
  }
}
