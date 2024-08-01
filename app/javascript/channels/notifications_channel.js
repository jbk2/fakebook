import consumer from "./consumer"

const NotificationsChannel = {
  subscribe(userId) {
    const channel = consumer.subscriptions.create({
      channel: "NotificationsChannel", userId: userId
    }, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`Connected to the Notification channel for user_id: ${userId}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log(`Disconnected from the Notification channel for user_id: ${userId}`);
      },

      received(data) {
        // the only thing that was sent was the data.action; either 'add_notification' or 'remove_notification'
        // pending this add or remove a ring on the conversations dropdown icon
        let conversationsIcon = document.querySelector("#conversations summary");

        if (data.action == "add_notification") {
          conversationsIcon.classList.add('ring');
        }

        if (data.action == "remove_notification") {
          conversationsIcon.classList.remove('ring');
        }
      }
    });
    return channel;
  }
}

export default NotificationsChannel;
