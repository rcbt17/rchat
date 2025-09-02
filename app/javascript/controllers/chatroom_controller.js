import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chatroom"
export default class extends Controller {
  static targets = ["characters", "message", "submit"];
  connect() {
    this.submitTarget.disabled = true;
    this.messageTarget.value = "";
  }

  update() {
    const leftCharacters = 300 - this.messageTarget.value.length;
    if (leftCharacters < 1) {
      this.messageTarget.value = this.messageTarget.value.substr(0, 299);
      this.charactersTarget.innerHTML = `<p class="error-message"> 0 characters left</p>`;
    } else if (leftCharacters < 300) {
      this.charactersTarget.innerText = `${leftCharacters} characters left`;
      this.submitTarget.disabled = false;
    } else {
      this.submitTarget.disabled = true;
      this.charactersTarget.innerText = "";
    }
  }
}
