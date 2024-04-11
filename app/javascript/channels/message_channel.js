import consumer from "channels/consumer"

const messageChannel = consumer.subscriptions.create("MessageChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected to the message channel')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Disconnected from the message channel')
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(`Here's my data; ${data}`)
    const messageDisplay = document.querySelector('#message-display')
    messageDisplay.insertAdjacentHTML('beforeend', this.template(data))
  },

  template(data) {
    return `<article class="message">
              <div class="message-header">
                <p>${data.user.email}</p>
              </div>
              <div class="message-body">
                <p>${data.body}</p>
              </div>
            </article>`
  }

});

document.addEventListener('DOMContentLoaded', function() {

  const form = document.getElementById('message-form');
  const input = document.getElementById('message-input');

  if (form && input) {
    form.addEventListener('submit', function(e) {
      console.log('Form submitted');
      e.preventDefault();
      messageChannel.send({ body: input.value });
      input.value = '';
    });
  }
});

