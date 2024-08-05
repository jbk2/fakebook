import consumer from "channels/consumer"

const ConversationsChannel = {
  subscribe(userId) {
    const channel = consumer.subscriptions.create({
      channel: "ConversationsChannel", currentUserId: userId
    }, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`%cConversationsChannel=>%c connected to user; ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },
      
      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log(`%cConversationsChannel=>%x disconnected for userId: ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },
      
      received(data) {
        // Called when there's incoming data on the websocket for this channel
        // want to up date the conversations content here (without killing
        // notifications and conversations stimulus controllers connexted to it)
        let conversationsFrame = document.getElementById('conversations');
        let currentUser = conversationsFrame.dataset.conversationsCurrentUserIdValue
        console.log(`%cConversationsChannel=>%c #received method called, with data; ${data}`, "color: red; font-weight: bold;", "");

        if (currentUser == data.recipient_id) {
          conversationsFrame.innerHTML = data.recipients_conversations_html;
          console.log(`%cConversationsChannel=>%c updated recipient's, user id; ${userId}, conversations frame`, "color: red; font-weight: bold;", "");
        } else if (currentUser == data.sender_id) {
          conversationsFrame.innerHTML = data.senders_conversations_html;
          console.log(`%cConversationsChannel=>%c updated sender's, user id; ${userId}, conversations frame`, "color: red; font-weight: bold;", "");
        }
      }
    });
    return channel;
  }
}

export default ConversationsChannel;