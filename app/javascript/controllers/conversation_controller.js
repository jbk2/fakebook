import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages"]
  static values = { conversationId: Number }
  
  connect() {
    console.log("ConversationStimulus=> connected!")
    console.log(`ConversationsStimulus=> conversationIDValue; ${this.conversationIdValue}`)

    this.scrollToBottom()
    this.channel = ConversationChannel.subscribe(this.conversationIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`ConversationStimulus=> unsubscribing from ConversationChannel for conversationId; ${this.conversationIdValue}`);
      this.channel.unsubscribe();
    }
    console.log("ConversationStimulus=> disconnecting");
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
