import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  connect() {

    this.currentUserId = document.body.dataset.currentUserId
    this.messageUserId = this.element.dataset.userId
    console.log(this.currentUserId)
    const isAuthor = String(this.currentUserId) === String(this.messageUserId)

      this.element.classList.toggle("message-cloud", isAuthor)
      this.element.classList.toggle("message-cloud-others", !isAuthor)
      this.element.scrollIntoView()

  }
}
