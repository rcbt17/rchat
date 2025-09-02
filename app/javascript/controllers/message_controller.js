import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.currentUserId = document.body.dataset.currentUserId;
    this.messageUserId = this.element.dataset.userId;
    this.messageSound = document.getElementById("message-sound");
    const isAuthor = String(this.currentUserId) === String(this.messageUserId);

    this.element.classList.toggle("message-cloud", isAuthor);
    this.element.classList.toggle("message-cloud-others", !isAuthor);
    this.messageSound.play();
    this.element.scrollIntoView();
  }
}
