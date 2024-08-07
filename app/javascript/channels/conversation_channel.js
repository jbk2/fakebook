import consumer from "channels/consumer"

const ConversationChannel = {
  subscribe(conversationId) {
    const channel = consumer.subscriptions.create({
      channel: "ConversationChannel", conversationId: conversationId
    }, {
      // Called when the subscription is ready for use on the server
      connected() {
        console.log(`%cConversationChannel=>%c connected, to conversationId: ${conversationId} scoped stream`, "color: red; font-weight: bold;", "");
      },
      
      // Called when the subscription has been terminated by the server
      disconnected() {
        console.log(`%cConversationChannel=>%c disconnected from conversationId: ${conversationId} scoped stream`, "color: red; font-weight: bold;", "");
      },

      // Called when there's incoming data on the websocket for this channel
      received(data) {
        console.log(`%cConversationChannel=>%c #received method called, with data;`, "color: red; font-weight: bold;", "", Object.keys(data));
        let messagesContainer = document.getElementById(`conversation-${conversationId}-card-messages`);
        if (messagesContainer) {
          messagesContainer.innerHTML += data.message_html;
          // ensure container scrolled to bottom to show the latest message
          messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        // Update each conversation participant's conversations turbo frame
        // let conversationsFrame = document.getElementById('conversations');
        // let currentUser = conversationsFrame.dataset.notificationsCurrentUserIdValue

        // if (currentUser == data.sender_id) {
        //   conversationsFrame.innerHTML = data.senders_conversations_html;
        // }
      }
    });
    return channel;
  }
}

export default ConversationChannel;