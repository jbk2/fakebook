import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conversation"
export default class extends Controller {

  static targets = [ "conversationCard" ]
  
  connect() {
    console.log("conversation Stimulus controller is now connected");
    console.log("conversationCard target, on Conversation controller found", this.conversationCardTarget)

    window.addEventListener('toggle-conversation-card', this.toggleConversationCard.bind(this));
    this.conversationCardTarget.classList.add("hidden");
  }

  disconnect() {
    window.removeEventListener('toggle-conversation-card', this.handleToggle.bind(this));
  }

  toggleConversationCard(event) {
    event.preventDefault();
    console.log("toggleConversationCard action called");
    this.loadTargetData(event.detail.id, event.detail.idType);
    this.conversationCardTarget.classList.toggle("hidden");
  }

  loadTargetData(id, idType) {
    console.log("loadTargetData called");
    console.log("id is", id);
    console.log("idType is;", idType);
    this.conversationCardTarget.innerHTML = `Message ${id} of type ${idType}`;
    // should find or create conversation, load all messages from conversation
  }

  insertConversationCard() {
    // insert conversation card html into conversationCardTarget
  }

  conversationCardHTML() {
  // build conversation card html here 
  }

  conversationCardHTML(userData) {
    // Construct HTML content based on userData
    return `
      <div class="card-body p-3">
        <div class="card-title">
          <div class="w-12 h-12 content-center rounded-full overflow-hidden mr-2 bg-slate-200">
            ${userData.hasProfilePhoto ? `<img src="${userData.profilePhotoUrl}" class="object-cover">` : '<i class="fa-regular fa-user text-center text-xl"></i>'}
          </div>
          <div>
            <h3 class="text-md font-bold mb-2">${userData.username}</h3>
          </div>
        </div>
        <div class="card-messages" id="message-display">
          <!-- Action cable broadcasted messages would be handled here -->
        </div>
        <div class="card-actions">
          <form id="message-form" action="/messages" accept-charset="UTF-8" method="post">
            <div class="field flex items-center bottom-0 mb-2">
              <div class="control">
                <input type="text" name="message[body]" id="message-input" class="bg-slate-100 rounded-full border-none" placeholder="Type a message...">
              </div>
              <input type="hidden" name="message[recipient_id]" value="${userData.id}">
              <div class="control">
                <button type="submit" class="btn btn-sm btn-primary ml-1 p-2">Send</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    `;
  }

}