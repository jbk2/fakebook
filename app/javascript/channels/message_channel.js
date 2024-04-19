import consumer from "channels/consumer"

const recipientId = document.getElementById('message_recipient_id').value;
console.log(`Recipient ID is: ${recipientId}`);

const messageChannel = consumer.subscriptions.create({ channel: "MessageChannel" }, {
  connected() {
    console.log('Connected to the message channel')
  },

  disconnected() {
    console.log('Disconnected from the message channel')
  },

  received(data) {
    console.log(`Here's my data: ${JSON.stringify(data, null, 2)}`);
    const messageDisplay = document.querySelector('#message-display')
    messageDisplay.insertAdjacentHTML('beforeend', this.template(data))
  },

  template(data) {
    const createdAtTime = formatDateTime(new Date(data.created_at));

    return `<article class="message">
              <div class="message-header">
                <p>${data.user.email}</p>
              </div>
              <div class="message-created-at">
                <p>${createdAtTime}</p>
              </div>
              <div class="message-body">
                <p>${data.body}</p>
              </div>
            </article>`
  }
});

function formatDateTime(date) {
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const seconds = date.getSeconds().toString().padStart(2, '0');

  return `${hours}:${minutes}:${seconds}`;
}


// document.addEventListener('DOMContentLoaded', function() {
//   const form = document.getElementById('message-form');
//   const input = document.getElementById('message-input');

//   if (form && input) {
//     form.addEventListener('submit', function(e) {
//       e.preventDefault();
//       const formData = new FormData(form);
//       const messageData = {};
//       formData.forEach((value, key) => {
//         messageData[key] = value;
//       });

//       console.log('Form submitted, default http post prevented');
//       messageChannel.send(messageData);
//       input.value = '';
//     });
//   }
// });

