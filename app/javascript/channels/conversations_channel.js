import consumer from "channels/consumer"

const ConversationsChannel = {
  subscribe(userId) {
    const channel = consumer.subscriptions.create({
      channel: "ConversationsChannel", currentUserId: userId
    }, {
      // Called when the subscription is ready for use on the server
      connected() {
        console.log(`%cConversationsChannel=>%c connected to user; ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },
      
      // Called when the subscription has been terminated by the server
      disconnected() {
        console.log(`%cConversationsChannel=>%x disconnected for userId: ${userId} scoped stream`, "color: red; font-weight: bold;", "");
      },
      
      // Called when there's incoming data on the websocket for this channel
      received(data) {
        // want to up date the conversations content here (without killing
        // notifications and conversations stimulus controllers connexted to it)
        let conversationsFrame = document.getElementById('conversations');
        let originalConversationsDropdown = document.getElementById('conversations-dropdown');
        console.log(`%cConversationsChannel=>%c #received method called, with data;`, "color: red; font-weight: bold;", "", Object.keys(data));

        if (data.close_conversations_frame) {
          originalConversationsDropdown.removeAttribute('open');
          console.log(`%cConversationsChannel=>%c closed conversations frame`, "color: red; font-weight: bold;", "");
        }

        if (data.conversations_html) {
          if (originalConversationsDropdown.open) {
            conversationsFrame.innerHTML = data.conversations_html;
            let updatedConversationsDropdown = document.getElementById('conversations-dropdown');
            updatedConversationsDropdown.setAttribute('open', '');
            let conversationsContainer = document.getElementById('conversations-container');
            conversationsContainer.scrollBottom = conversationsContainer.scrollHeight;
            console.log(`%cConversationsChannel=>%c updated user id; ${userId}'s, conversations frame + kept open`, "color: red; font-weight: bold;", "");
          } else {
            conversationsFrame.innerHTML = data.conversations_html;
            console.log(`%cConversationsChannel=>%c updated user id; ${userId}'s, conversations frame + kept closed`, "color: red; font-weight: bold;", "");
          }
        }
      }
    });
    return channel;
  }
}

export default ConversationsChannel;