import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages"]
  static values = { conversationId: Number }
  
  connect() {
    console.log("Conversation Stimulus Controller is now connected!")
    console.log(`The value of the conversationID from the convo card is ${this.conversationIdValue}`)
    console.log("messages target found: ", this.messagesTarget)

    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    this.channel = ConversationChannel.subscribe(this.conversationIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`unsubscribing this.channel ${this.channel}`);
      this.channel.unsubscribe();
    }
    console.log("disconnecing Conversation Stimulus Controller");
  }
}
