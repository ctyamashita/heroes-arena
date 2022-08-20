import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'form', 'inputText', 'inputSelect' ]

  connect() {
    console.log('Hello from class_filter_controller.js')
  }

  checkClass() {
    if (this.inputSelectTarget.value === '') {
      window.location.href = "/creatures";
    } else {
      this.inputTextTarget.value = this.inputSelectTarget.value
      this.formTarget.submit();
    }
  }
}
