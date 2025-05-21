import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "toggleIcon"]

  connect() {
    console.log(`%cinputVisibility Stimulus Controller =>%c connected!`, "color: green; font-weight: bold;", "");
    console.log(`input target ${this.inputTarget ? '' : 'NOT '}found`);
    console.log(`toggleIcon target ${this.inputTarget ? '' : 'NOT '}found`);
  }

  toggle(event) {
    event.preventDefault();
    const input = this.inputTarget;
    const toggleIcon = this.toggleIconTarget;
    if (input.type === "password") {
      input.type = "text";
      // change icon to eye-slash
      toggleIcon.classList.remove("fa-eye");
      toggleIcon.classList.add("fa-eye-slash");
    } else {
      input.type = "password";
      // change icon to eye
      toggleIcon.classList.remove("fa-eye-slash");
      toggleIcon.classList.add("fa-eye");
    }
  }

}
