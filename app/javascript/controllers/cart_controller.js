import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "decrementButton", "incrementButton"];

  connect() {
    this.updateDecrementButton();
  }

  increment(event) {
    if (this.inputTarget.value == 0) {
      this.inputTarget.value = 1;
      this.element.submit();
    } else {
      this.inputTarget.value = parseInt(this.inputTarget.value) + 1;
    }
    this.updateDecrementButton();
  }

  decrement(event) {
    let currentValue = parseInt(this.inputTarget.value);

    if (currentValue > 0) {
      this.inputTarget.value = currentValue - 1;
    }
    // Automatically submit the form if the quantity reaches 0
    if (this.inputTarget.value == 0) {
      this.element.submit();
    }

    this.updateDecrementButton();
  }

  updateDecrementButton() {
    const decrementButton = this.decrementButtonTarget;
    decrementButton.disabled = parseInt(this.inputTarget.value) <= 0;
  }
}
