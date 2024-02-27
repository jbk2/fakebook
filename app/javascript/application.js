// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { showModal } from "./photo_modal"

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-modal-id]').forEach(element => {
    element.addEventListener('click', () => {
      const modalId = element.getAttribute('data-modal-id');
      showModal(modalId);
    });
  });
});
