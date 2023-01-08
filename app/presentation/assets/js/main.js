
calculate_focus=()=>{
let delayed;
const ctx = document.getElementById("example").getContext("2d");
let dates = document.getElementsByClassName('focus-date');
console.log(dates);
let date_arr = Array.prototype.map.call(dates, function(obj) {
  return obj.innerText;
});;
date_arr.shift();
let times = document.getElementsByClassName('focus-time');
// console.log(times);
let times_arr = Array.prototype.map.call(times, function(obj) {
  return obj.innerText.split(' ')[0];
});;
times_arr.shift();
console.log(times_arr)
let rest_times = document.getElementsByClassName('rest-time');
// console.log(times);
let rest_times_arr = Array.prototype.map.call(rest_times, function(obj) {
  return obj.innerText.split(' ')[0];
});;
rest_times_arr.shift();
console.log(rest_times_arr)

const myChart = new Chart(ctx, {
  type: "bar",
  data: {
    labels: date_arr,
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: "top",
        },
        title: {
          display: true,
          text: "Chart.js Bar Chart",
        },
      },
    },
    datasets: [
      {
        label: "Work Time",
        data: times_arr,
        backgroundColor: ["rgba(166, 187, 141,1)"],
        borderColor: ["rgba(166, 187, 141,1)"],
        borderWidth: 0.5,
        borderRadius: 10,
        borderSkipped: false,
      },
      {
        label: "Rest Time",
        data: rest_times_arr,
        backgroundColor: ["rgb(234, 231, 177)"],
        borderColor: ["rgb(234, 231, 177)"],
        borderWidth: 0.5,
        borderRadius: 10,
        borderSkipped: false,
      },
    ],
  },
  options: {
    scales: {
      x: {
        grid: {
          display: false,
        },
        ticks: {
          color: "#fff",
        },
      },
      y: {
        grid: {
          drawBorder: true,
          color: "rgba(166, 187, 141,1)",
        },
        ticks: {
          color: "#fff",
        },
      },
    },
    y: {
      beginAtZero: true,
    },
    animation: {
      onComplete: () => {
        delayed = true;
      },
      delay: (context) => {
        let delay = 0;
        if (
          context.type === "data" &&
          context.mode === "default" &&
          !delayed
        ) {
          delay = context.dataIndex * 300 + context.datasetIndex * 100;
        }
        return delay;
      },
    },
    plugins: {
      legend: {
        labels: {
          color: "#fff",
        },
      },
    },
  },
});
}
// fix_high=()=>{
//   let windowsVH = window.innerHeight / 100;
//     document.querySelector('.view-pic').style.setProperty('--vh', windowsVH + 'px');
//     window.addEventListener('resize', function() {
//         document.querySelector('.view-pic').style.setProperty('--vh', windowsVH + 'px');
//     });
// }

function setCorrectViewHeight() {
  const windowsVH = window.innerHeight / 100
  console.log(windowsVH)
  document.getElementsByClassName('view-pic')[0].style.setProperty('--vh', windowsVH + 'px')
}

window.addEventListener('resize', ()=>{
  if (vw === window.innerWidth) {
    return;
  }
 
  vw = window.innerWidth;
  setCorrectViewHeight();
});
 
// setCorrectViewHeight();

$(document).ready(function(){
  $(".alert").fadeTo(2000,500).slideUp(500, function() {
    $(".alert").slideUp(500);
  });
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
  // setCorrectViewHeight();
  calculate_focus();
  // fix_high();
});

//  pomodoro

const buttonPlay=document.getElementById('buttonPlay');
const playIcon=document.getElementById('playIcon');
const buttonReset=document.getElementById('buttonReset');
const leftTime=document.getElementById('leftTime');

// const breakTime = document.getElementById('labelSessionBreak');

const workTitle = document.getElementById('work-title');
const restTitle = document.getElementById('rest-title');
const workTime = document.getElementById('work-period-time');
const restTime = document.getElementById('rest-period-time');
const workDecrease = document.getElementById('work-decrease');
const workIncrease = document.getElementById('work-increase');
const restDecrease = document.getElementById('rest-decrease');
const restIncrease = document.getElementById('rest-increase');

let isPlay=false;
let interval;
let isWork=true;
const arrayTime = leftTime.innerText.split(":");
let timeLeft = parseInt(arrayTime[0] * 60) + parseInt(arrayTime[1]); 

buttonReset.addEventListener('click', ()=>{
  reset();
})

function reset(){
  isWork=true;
  isPlay=false;
  timeLeft=parseInt(workTime.innerText)*60; 
  const minutesAndSeconds = convertSeconds(timeLeft);
  leftTime.innerText = `${('0'+minutesAndSeconds.minutes).slice(-2)}:${('0'+minutesAndSeconds.seconds).slice(-2)}`;
  workTitle.classList.remove('work-active');
  restTitle.classList.remove('rest-active'); 
  if(playIcon.classList.contains('fa-circle-pause')){
   
    playIcon.classList.add('fa-circle-play');
    playIcon.classList.remove('fa-circle-pause');

  }
}

buttonPlay.addEventListener('click',()=>{
  console.log(timeLeft);
  // safe_time();
  isPlay=!isPlay;
  if(isPlay){
    if((!workTitle.classList.contains('work-active'))&& !restTitle.classList.contains('rest-active')){
      workTitle.classList.add('work-active');
    }
    
    playIcon.classList.add('fa-circle-pause');
    playIcon.classList.remove('fa-circle-play');
    if(interval){
      clearInterval(interval)
    }
    interval = setInterval(handleTime,1000);
    function handleTime(){
      if(timeLeft<=0){
          if(isWork){
              timeLeft=parseInt(restTime.innerText)*60;
              workTitle.classList.remove('work-active');
              restTitle.classList.add('rest-active'); 
          }
          else{
              safe_time();
              timeLeft=parseInt(workTime.innerText)*60; 
              workTitle.classList.add('work-active');
              restTitle.classList.remove('rest-active'); 
          }
          isWork=!isWork;
      }
      else if(!isPlay){
        clearInterval(interval);
      }
      else if(timeLeft>0 ){
        timeLeft--;
        const minutesAndSeconds = convertSeconds(timeLeft);
        leftTime.innerText = `${('0'+minutesAndSeconds.minutes).slice(-2)}:${('0'+minutesAndSeconds.seconds).slice(-2)}`;
      }


    }
  }
  else{
    playIcon.classList.add('fa-circle-play');
    playIcon.classList.remove('fa-circle-pause');
  }
})

function convertSeconds(seconds) {
    return {
        minutes: Math.floor(seconds / 60), // nombre de minutes
        seconds: seconds % 60 // nombre de secondes
    }
}


function handleIncrease(currentDom,isIncrease){
  value=currentDom.innerText;
  if(value>1){
    value=parseInt(value)+isIncrease;
    currentDom.innerText=value;
  }
  reset();
}

// workTime.innerText="123";
workIncrease.addEventListener('click',()=>{
  handleIncrease(workTime,1);
});
workDecrease.addEventListener('click',()=>{
  handleIncrease(workTime,-1);
});

restIncrease.addEventListener('click',()=>{
  handleIncrease(restTime,1);
});
restDecrease.addEventListener('click',()=>{
  handleIncrease(restTime,-1);
});

safe_time=()=>{
  topic_id=document.getElementById('topic_id').getAttribute("value")
  console.log(topic_id);
  if (window.location.href.includes('topic')){
    url_arr=window.location.href.split('/')
    redirect = url_arr.slice(0,5).join('/')+'/'+restTime.innerText +'/' + workTime.innerText+'/'+(url_arr.reverse()).slice(0,1)
    console.log(redirect)
    window.location = redirect
    // window.location = window.location.href.split('/').slice(0,6).join('/')+'/' +restTime.innerText +'/' + workTime.innerText;
  }
  else{
    console.log(window.location.href.split('/').slice(0,6).join('/')+'/' +restTime.innerText +'/' + workTime.innerText)
    window.location = window.location.href.split('/').slice(0,6).join('/')+'/' +restTime.innerText +'/' + workTime.innerText;
  }
}

