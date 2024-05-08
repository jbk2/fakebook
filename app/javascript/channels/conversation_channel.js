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
  
        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log(`Disconnected from the conversation channel for conversationId: ${conversationId}`);
        },
  
        received(data) {
          // Called when there's incoming data on the websocket for this channel
          let messagesContainer = document.getElementById(`conversation-${conversationId}-card-messages`);
          console.log(`message data: body: ${data.body}, message user.id: ${data.user_id}, message convo.id : ${data.conversation_id}`);
          if (messagesContainer) {
            messagesContainer.innerHTML += data.message_html;
            let messages = messagesContainer.querySelectorAll('.flex');
            let lastMessage = messages[messages.length - 1]; // Get the last message element
            let imageElement = lastMessage.querySelector('img');
            if (imageElement) {
              imageElement.src = data.image_url;
            }
          }
        },
  
        send_message: function() {
          return this.perform('send_message');
        }
      }
    );
    return channel;
  }
}

export default ConversationChannel;