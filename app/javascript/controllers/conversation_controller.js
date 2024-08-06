import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages"]
  static values = { conversationId: Number }
  
  connect() {
    console.log("%cConversationStimulus=>%c connected!", "color: blue; font-weight: bold;", "")
    console.log(`ConversationsStimulus=> conversationIDValue; ${this.conversationIdValue}`)

    this.scrollToBottom()
    this.channel = ConversationChannel.subscribe(this.conversationIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`%cConversationStimulus=>%c unsubscribing from ConversationChannel for conversationId; ${this.conversationIdValue}`, "color: blue; font-weight: bold;", "");
      this.channel.unsubscribe();
    }
    console.log("%cConversationStimulus=>%c disconnecting", "color: blue; font-weight: bold;", "");
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
