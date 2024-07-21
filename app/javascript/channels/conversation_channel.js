import consumer from "channels/consumer"

const ConversationChannel = {
  subscribe(conversationId) {
    const channel = consumer.subscriptions.create({
      channel: "ConversationChannel", conversationId: conversationId
    }, {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log(`Connected to the conversation channel for conversationId: ${conversationId}`);
        },
        
        // Called when the subscription has been terminated by the server
        disconnected() {
          console.log(`Disconnected from the conversation channel for conversationId: ${conversationId}`);
        },
  
        // Called when there's incoming data on the websocket for this channel
        received(data) {
          let messagesContainer = document.getElementById(`conversation-${conversationId}-card-messages`);
          console.log(`here's the message data: ${data.message_html}`);
          if (messagesContainer) {
            messagesContainer.innerHTML += data.message_html;
            // ensure scroll height is adjusted to show the latest message
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
          }

          // Update the conversations turbo frame
          let conversationsFrame = document.getElementById('conversations');
          let currentUser = conversationsFrame.dataset.currentUserId
          console.log(`currentUser: ${currentUser}`);

          if (currentUser == data.sender_id) {
            conversationsFrame.innerHTML = data.senders_conversations_html;
          }
          if (currentUser == data.recipient_id) {
            conversationsFrame.innerHTML = data.recipients_conversations_html;
          }

        }//,
  
        // send_message: function() {
        //   return this.perform('send_message');
        // }
      }
    );
    return channel;
  }
}

export default ConversationChannel;