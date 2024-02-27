export function showModal(modalId) {
  var modal = document.getElementById(modalId);
  if (modal) {
    modal.showModal();
  } else {
    console.error("Modal not found: " + modalId);
  }
}