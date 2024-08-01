import { Controller } from "@hotwired/stimulus"
import NotificationsChannel from "../channels/notifications_channel";

// Connects to data-controller="notifications"
export default class extends Controller {

  static values = { currentUserId: Number }

  connect() {
    console.log("Notifications Stimulus Controller is now connected!")
    console.log(`The value of the currentUserId from the convos card is ${this.currentUserIdValue}`)

    this.channel = NotificationsChannel.subscribe(this.currentUserIdValue);
  }

  disconnect() {
    if (this.channel) {
      console.log(`unsubscribing from the notifications channel for currentUserId ${this.currentUserIdVale}`);
      this.channel.unsubscribe();
    }
    console.log("disconnecting Notifications Stimulus Controller");
  }
}
