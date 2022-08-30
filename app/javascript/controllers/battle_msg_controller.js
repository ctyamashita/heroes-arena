import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'enemyHp', 'playerHp' ]

  connect() {
    console.log('Hello from battle_msg_controller.js');
  }

  actionSubmit() {
    if (this.enemyHpTarget.innerHTML === '0' || this.playerHpTarget.innerHTML === '0') {
      this.modalBtnTarget.click();
    }
  }

  window.load = this.actionSubmit();
}
