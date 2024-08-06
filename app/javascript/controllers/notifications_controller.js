import { Controller } from "@hotwired/stimulus"
import NotificationsChannel from "../channels/notifications_channel";

// Connects to data-controller="notifications"
export default class extends Controller {

  static values = { currentUserId: Number }
  static targets = [ "dropdown" ]

  connect() {
    console.log(`%cNotificationsStimulus=>%c connected!\n
      currentUserIdValue: ${this.currentUserIdValue}\n
      'dropdown' target found: ${this.dropdownTarget}`, "color: blue; font-weight: bold;", "");

    // Subscribe to the NotificationsChannel, notification_current_user.id stream, so that we can receive
    // real time notifications to add or remove a ring on the conversations dropdown icon
    this.channel = NotificationsChannel.subscribe(this.currentUserIdValue);

    // Add a listener to detect when the dropdown icon is opened, and if so 1) remove the notification ring
    // 2) update all messages to read
    this.dropdownTarget.addEventListener('toggle', this.handleOpeningConversationsDropdown.bind(this));

    // Each time ths controller instantiates, check whether this user has any unread messages, if so
    // add a ring to the conversations dropdown icon, if not remove any ring present
    this.checkForUnreadMessages();
  }

  handleOpeningConversationsDropdown(event) {
    console.log("%cNotificationsStimulus=>%c dropdown toggled", "color: blue; font-weight: bold;", "");

    // If the dropdown is open, remove the ring & all of users' conversations as read in the db
    if (this.dropdownTarget.open) {
      this.dropdownTarget.classList.remove('ring');

      fetch(`/mark_all_read?user_id=${this.currentUserIdValue}`, {
        method: "PATCH",
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": this.getCSRFToken()
        },
        credentials: 'include'
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        console.log(response);
        return response.json();
      })
      .then(data => {
        console.log("%cNotificationsStimulus#handleOpeningConversationsDropdown=>%c response data from fetch conversations/mark_all_read;", "color: blue; font-weight: bold;", "", data);
      })
      .catch(error => console.error("%cNotificationsStimulus#handleOpeningConversationsDropdown=>%cError marking all messages read:", "color: blue; font-weight: bold;", "", error));
    }
  }

  checkForUnreadMessages() {
    fetch(`/check_unread?user_id=${this.currentUserIdValue}`, {
      headers: {
        "Accept": "application/json"
      },
      credentials: 'include'
    })
    .then(response => {
      console.log(response);
      return response.json();
    })
    .then(data => {
      console.log("%cNotificationsStimulus#checkForUnreadMessages=>%c response data from fetch conversations/check_unread;", "color: blue; font-weight: bold;", "", data);
      if (data.unread_messages && !this.isConversationCardOpen()) {
        this.dropdownTarget.classList.add('ring');
        console.log("%cNotificationsStimulus=>%c Added notification ring", "color: blue; font-weight: bold;", "");
      } else {
        this.dropdownTarget.classList.remove('ring');
        console.log("%cNotificationsStimulus=>%c Removed notification ring", "color: blue; font-weight: bold;", "");
      }
    })
    .catch(error => console.error("%cNotificationsStimulus#handleOpeningConversationsDropdown=>%c Error checking for unread messages:", "color: blue; font-weight: bold;", "", error));
  }

  getCSRFToken() {
    return document.querySelector("meta[name='csrf-token']").getAttribute("content");
  }
  
  isConversationCardOpen() {
    const turboFrame = document.querySelector('turbo-frame[id="conversation-card"]');
    // Ensure that the 'conversation' data-controller is defined
    if (turboFrame.getAttribute('data-controller')?.includes("conversation")) {
      console.log("%cNotificationsStimulus#isConversationCardOpen=>%c ConversationController is present", "color: blue; font-weight: bold;", "");
      return true;
    } else {
      return false;
    }
  }

  disconnect() {
    if (this.channel) {
      console.log(`%cNotificationsStimulus=>%c unsubscribing from NotificationsChannel for currentUserIdValue; ${this.currentUserIdValue}`, "color: blue; font-weight: bold;", "");
      this.channel.unsubscribe();
    }
    console.log("%cNotificationsStimulus=> disconnecting", "color: blue; font-weight: bold;");
  }
}
