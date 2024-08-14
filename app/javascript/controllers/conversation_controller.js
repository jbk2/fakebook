import { Controller } from "@hotwired/stimulus"
import ConversationChannel from "../channels/conversation_channel";

export default class extends Controller {
  static targets = ["messages", "messageInputField"]
  static values = { conversationId: Number }
  
  connect() {
    console.log(`%cConversationStimulus=>%c connected!`, "color: blue; font-weight: bold;", "");
    console.log(`conversationIDValue; ${this.conversationIdValue}\n`);
    console.log(`Message input field target ${this.messagesTarget ? '' : 'NOT '}found`);
    console.log(`Message input field target ${this.messageInputFieldTarget ? '' : 'NOT '}found`);

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
