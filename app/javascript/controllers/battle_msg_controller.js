import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'enemyHp', 'playerHp', 'modalBtn' ]

  connect() {
    console.log('Hello from battle_msg_controller.js');
    console.log(this.enemyHpTarget.innerHTML, this.playerHpTarget.innerHTML)
    if (this.enemyHpTarget.innerHTML === '0' || this.playerHpTarget.innerHTML === '0') {
      this.modalBtnTarget.click();
    }
  }

}
