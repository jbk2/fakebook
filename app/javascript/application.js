// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { showModal } from "./photo_modal"

function initModalListenersOnPosts() {
  const postsContainer = document.getElementById('posts');

  if (postsContainer) {
    postsContainer.addEventListener('click', function(event) {
      const target = event.target.closest('[data-modal-id]');
      if (target) {
        const modalId = target.getAttribute('data-modal-id');
        showModal(modalId);
      }
    });
  }
}

document.addEventListener('turbo:load', initModalListenersOnPosts);