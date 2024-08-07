import consumer from "./consumer"

function getCSRFToken() {
  return document.querySelector("meta[name='csrf-token']").getAttribute("content");
}

const NotificationsChannel = {
  subscribe(userId) {
    const channel = consumer.subscriptions.create({
      channel: "NotificationsChannel", userId: userId
    }, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`%cNotificationsChannel=>%c connected to user; ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log(`%cNotificaationsChannel=>%c disconnected for userId: ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },

      received(data) {
        // Get dropdown
        // Is it open, if so do nothing (or remove ring, but should be done already by stimulus controller)
        // If not open, add ring
        let conversationsDropdown = document.getElementById('conversations-dropdown');
        console.log(`%cNotificaationsChannel=>%c; #received called with action; ${data.action} for recipient_id; ${data.recipient_id}`, "color: red; font-weight: bold;", "");

        if (conversationsDropdown.open) {
          // Although #mark_all_read will have already been called when conversations Stimulus controller was opened
          // we must call it again here since a new message was sent since the dropdown was opened
          fetch("/mark_all_read", {
            method: "PATCH",
            headers: {
              "Accept": "application/json",
              "X-CSRF-Token": getCSRFToken(),
              "X-Requested-With": "XMLHttpRequest"
            },
            credentials: 'include'
          }).then(response => {
            if (!response.ok) {
              throw new Error('Network response was not ok');
            }
            console.log(response);
            return response.json();
          })
          .then(data => {
            console.log("%cNotificationsChannel#mark_all_read=>%c response data from fetch conversations/mark_all_read;", "color: red; font-weight: bold;", "", data);
          })
          .catch(error => console.error('%cNotificationsChannel=>%c Error marking all messages read; ', "color: red; font-weight: bold;", "", error));

        } else {
          conversationsDropdown.classList.add('ring');
          console.log(`%cNotificationsChannel=>%c Added notification ring to user_id; ${userId}'s conversations dropdown`, "color: red; font-weight: bold;", "");
        }
      }

    });
    return channel;
  }
}

export default NotificationsChannel;
