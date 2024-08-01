import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages"]
  static values = { conversationId: Number }
  
  connect() {
    console.log("Conversation Stimulus Controller is now connected!")
    console.log(`The value of the conversationID from the convo card is ${this.conversationIdValue}`)

    this.scrollToBottom()
    this.channel = ConversationChannel.subscribe(this.conversationIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`unsubscribing from the conversation channel for the convo with id; ${this.conversationIdValue}`);
      this.channel.unsubscribe();
    }
    console.log("disconnecting Conversation Stimulus Controller");
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
