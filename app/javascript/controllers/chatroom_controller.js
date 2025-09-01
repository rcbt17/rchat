import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatroom"
export default class extends Controller {
  static targets = ["currentUserId"]
  connect() {
    this.currentUserId = this.element.dataset.currentUserId
   // console.log(this.currentUserId)
  }

  setMessageClass() {

  }
}
