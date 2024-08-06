import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages", "messageInputField"]
  static values = { conversationId: Number }
  
  connect() {
    console.log(`%cConversationStimulus=>%c connected!\n
      conversationIDValue; ${this.conversationIdValue}\n
      messages target found; ${this.messagesTarget}\n
      message-input-field target found; ${this.messageInputFieldTarget}`, "color: blue; font-weight: bold;", "")

    this.scrollToBottom()
    this.messageInputFieldTarget.focus();
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
