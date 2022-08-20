import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'submitBtn', 'btnPlus', 'btnMinus', 'remain', 'form' ]

  connect() {
    console.log('Hello from stat_points_controller.js')
    // console.log(this.testTarget)
    this.updateBtn
  }

  updateStats() {
    let atk = document.querySelector('#creature_atk');
    let def = document.querySelector('#creature_def');
    let spd = document.querySelector('#creature_spd');
    let dex = document.querySelector('#creature_dex');
    let int = document.querySelector('#creature_int');
    let luk = document.querySelector('#creature_luk');

    atk.value = parseInt(document.querySelector('#atk').innerHTML);
    def.value = parseInt(document.querySelector('#def').innerHTML);
    spd.value = parseInt(document.querySelector('#spd').innerHTML);
    dex.value = parseInt(document.querySelector('#dex').innerHTML);
    int.value = parseInt(document.querySelector('#int').innerHTML);
    luk.value = parseInt(document.querySelector('#luk').innerHTML);
  };

  updateBtn() {
    this.btnMinusTargets.forEach((btn) => {
      let rowValue = parseInt(btn.previousElementSibling.innerHTML);
      rowValue > 1 ? btn.classList.remove('disabled') : btn.classList.add('disabled')
    })

    this.btnPlusTargets.forEach((btn) => {
      let rPoints = parseInt(this.remainTarget.innerHTML);
      rPoints === 0 ? btn.classList.add('disabled') : btn.classList.remove('disabled')
    })
  }

  plusHandler(e) {
    let value = parseInt(e.target.nextElementSibling.innerHTML);
    let rPoints = parseInt(this.remainTarget.innerHTML);

    if (rPoints > 0) {
      e.target.nextElementSibling.innerHTML = value + 1;
      this.remainTarget.innerHTML = rPoints - 1;

      this.updateBtn()
    }
    this.updateStats()
  };

  minusHandler(e) {
    let value = parseInt(e.target.previousElementSibling.innerHTML);
    let rPoints = parseInt(this.remainTarget.innerHTML);

    if (value > 1) {
      e.target.previousElementSibling.innerHTML = value - 1;
      this.remainTarget.innerHTML = rPoints + 1;
      this.updateBtn()

    }
    this.updateStats()
  };

  submitBtn() {
    let rPoints = parseInt(this.remainTarget.innerHTML);
    rPoints === 0 ? document.querySelector('form').submit() : alert(`You still have ${rPoints} points remaining.`);
  };
}



// const statRows = document.querySelectorAll('.stat-row');
// const remainingPointsEl = document.querySelector('.r-points');
// const submitBtn = document.querySelector('#submitBtn');

// submitBtn.addEventListener('click', function() {
//   const rPoints = parseInt(remainingPointsEl.innerHTML);
//   rPoints === 0 ? document.querySelector('form').submit() : alert(`You still have ${rPoints} points remaining.`)
// })

// statRows.forEach((row) => {
//   const valueEl = row.querySelector('span');
//   const btnPlus = row.firstElementChild;
//   const btnMinus = row.lastElementChild;
//   let value = parseInt(valueEl.innerHTML);
//   let rPoints = parseInt(remainingPointsEl.innerHTML);
//   if (value === 1) btnMinus.classList.add('disabled');
//   if (rPoints === 0) btnMinus.classList.add('disabled');

//   const plusHandler = () => {
//     let rPoints = parseInt(remainingPointsEl.innerHTML);
//     let value = parseInt(valueEl.innerHTML);
//     if (rPoints > 0) {
//       valueEl.innerHTML = value + 1;
//       remainingPointsEl.innerHTML = rPoints - 1;
//       statRows.forEach((row) => {
//         let rowValue = parseInt(row.querySelector('span').innerHTML);
//         rPoints = parseInt(remainingPointsEl.innerHTML);
//         rowValue > 1 ? row.lastElementChild.classList.remove('disabled') : row.lastElementChild.classList.add('disabled')
//         rPoints > 0 ? row.firstElementChild.classList.remove('disabled') : row.firstElementChild.classList.add('disabled')
//       });
//     }
//   }

//   const minusHandler = () => {
//     let rPoints = parseInt(remainingPointsEl.innerHTML);
//     let value = parseInt(valueEl.innerHTML);

//     if (value > 1) {
//       valueEl.innerHTML = value - 1;
//       remainingPointsEl.innerHTML = rPoints + 1;
//       statRows.forEach((row) => {
//         let rowValue = parseInt(row.querySelector('span').innerHTML);
//         rPoints = parseInt(remainingPointsEl.innerHTML);
//         rowValue > 1 ? row.lastElementChild.classList.remove('disabled') : row.lastElementChild.classList.add('disabled')
//         rPoints === 0 ? row.firstElementChild.classList.add('disabled') : row.firstElementChild.classList.remove('disabled')
//       });
//     }
//   }

//   btnPlus.addEventListener('click', plusHandler);
//   btnMinus.addEventListener('click', minusHandler);

//   const updateStats = () => {
//     let atk = document.querySelector('#creature_atk');
//     let def = document.querySelector('#creature_def');
//     let spd = document.querySelector('#creature_spd');
//     let dex = document.querySelector('#creature_dex');
//     let int = document.querySelector('#creature_int');
//     let luk = document.querySelector('#creature_luk');

//     atk.value = parseInt(document.querySelector('#atk').innerHTML);
//     def.value = parseInt(document.querySelector('#def').innerHTML);
//     spd.value = parseInt(document.querySelector('#spd').innerHTML);
//     dex.value = parseInt(document.querySelector('#dex').innerHTML);
//     int.value = parseInt(document.querySelector('#int').innerHTML);
//     luk.value = parseInt(document.querySelector('#luk').innerHTML);
//   }

//   // valueEl.addEventListener('change', updateStats);
//   btnMinus.addEventListener('click', updateStats);
//   btnPlus.addEventListener('click', updateStats);
// });
