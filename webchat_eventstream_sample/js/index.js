import { EventStreamsRPCProxy } from './eventstreamsrpc.js';

let lastID = 0;
let superToken = "";
let queueNameTest = "chat";
let eventStreamsRPCUrl = appConfig.URL;

let colorArray = ['#FF6633', '#FFB399', '#FF33FF', '#00B3E6',
  '#E6B333', '#3366E6', '#999966', '#B34D4D',
  '#80B300', '#809900', '#E6B3B3', '#6680B3', '#66991A',
  '#FF99E6', '#FF1A66', '#E6331A',
  '#66994D', '#B366CC', '#4D8000', '#B33300', '#CC80CC',
  '#66664D', '#991AFF', '#E666FF', '#4DB3FF', '#1AB399',
  '#E666B3', '#33991A', '#CC9999', '#B3B31A',
  '#4D8066', '#809980', '#999933',
  '#FF3380', '#CCCC00', '#4D80CC', '#9900B3',
  '#E64D66', '#4DB380', '#FF4D4D', '#6666FF'];

let imageArray = [
  'anjali.png',
  'arjun.png',
  'jorge.png',
  'maya.png',
  'rahul.png',
  'sadona.png',
  'sandy.png',
  'sid.png',
  'steve.png'
]

let userColor = {
  'You': "black"
};

let userPhoto = {
  'You': 'adam.png'
}

let messageList = [];

let inputElt = document.getElementById('sender-input');
let loginElt = document.getElementById('chatuser');

let notification = new Audio('audio/notification.mp3');

let today = new Date("2020-12-15");
let alredyToday = 0;

inputElt.addEventListener("input", function () {
  if (this.value == '') {
    setButtonDisabled();
  } else {
    setButtonEnable();
  }
})

loginElt.addEventListener("input", function () {
  if (this.value == '') {
    setLoginBtnDisabled();
  } else {
    setLoginBtnEnabled();
  }
})

document.addEventListener("DOMContentLoaded", function (e) {
  let user = ""

  // Recupare i dati dal sessionStorage
  user = sessionStorage.getItem('chatuser');

  const formLogin = document.querySelector("#loginForm");
  if (user == "" || user == null) {
    formLogin.addEventListener("submit", function (e) {
      e.preventDefault()
      user = e.target.chatuser.value;
      sessionStorage.setItem('chatuser', user);

      enableChat(user);
    })
  } else {
    enableChat(user);
  }

  // Timeout con chiamata
  // Nel dmsGetMessage, se torna qualcosa che non è timout true, allora rischedula dmsGetMessage
  const form = document.querySelector("#chatForm")
  form.addEventListener("submit", function (e) {
    e.preventDefault()
    postMessage(e.target)
  })

})

// cache size limit function
function limitMessageSize() {
  if (messageList.length > 30) {
    // cancellare li e rimuovere dalla lista il primo messaggio
    const oldMessage = document.querySelector(`[data-id="${messageList[0].messageid}"]`);
    oldMessage.remove();
    messageList.shift();
  }

}

function getProxy() {
  return new EventStreamsRPCProxy(eventStreamsRPCUrl);
}

function getToken() {
  let proxy = getProxy();
  return proxy.login(appConfig.USER, appConfig.PWD)
    // return proxy.login('public_chat', 'q1w2e3r4T!')
    .then(function (res) {
      superToken = res.token;
    });
}

//  Prendi messaggi
function dmsGetMessage(lastKnownMsgID) {
  let proxy = getProxy();
  // Solo la prima volta deve chiedere il last, le altre volte deve chiedere l'id salvato
  proxy.dequeueMessage(superToken, queueNameTest, lastKnownMsgID, 5)
    .then(function (messages) {
      if (messages.data) {
        messages = messages.data;
      }
      
      if (!messages.timeout) {
        renderMessage(messages)
      }
      setTimeout(() => {
        dmsGetMessage(lastID);
      }, 1000);
    });
}

//  Posta messaggi
function postMessage(form) {
  let proxy = getProxy();
  let queueMessageTest = {
    sender: form.sender.value,
    message: htmlEntities(form.message.value)
  };
  form.message.value = "";

  var btn = document.getElementById('button-sender');
  var input = document.getElementById('sender-input');
  btn.setAttribute('disabled', true);
  input.setAttribute('disabled', true);

  proxy.enqueueMessage(superToken, queueNameTest, queueMessageTest)
    .then(function () {
      var btn = document.getElementById('button-sender');
      var input = document.getElementById('sender-input');
      // Viene disabilitato dall'evento input
      // btn.removeAttribute('disabled');
      input.removeAttribute('disabled');
      input.focus();
    });
}

function renderMessage(message) {
  message = message[0];
  if (lastID != message.messageid) {
    lastID = message.messageid;
    messageList.push(message);
    const list = document.querySelector("#message-list");
    var li = document.createElement('li')

    let sender = document.querySelector("#sender").value
    let classe = "";

    if (message.message.sender == sender) {
      sender = "You"
      classe = "replies msgdms";
    } else {
      sender = message.message.sender
      classe = "sent msgdms";
      notification.play();
    }

    let msgDate = new Date(message.createdatutc).toDateString();

    if (new Date(today).toDateString() < msgDate) {
      today = msgDate;
      msgDate = new Date(msgDate).toISOString().slice(0, 10).replace(/-/g, "/");
      makeDateSpan(msgDate);
    } else if(!alredyToday) {
      msgDate = "TODAY";
      makeDateSpan(msgDate);
      alredyToday = 1;
    }

    li.setAttribute("data-id", message.messageid)
    li.setAttribute("class", classe)

    list.appendChild(li);
    li.innerHTML = makeLi(message.message, sender, message.createdatutc);

    limitMessageSize();

    var objDiv = document.getElementById("real-chat");
    objDiv.scrollTop = objDiv.scrollHeight;
  }
}

function makeLi(message, sender, datetime) {
  // Random color
  if (!userColor[message.sender]) {
    userColor[message.sender] = colorArray[Math.floor(Math.random() * colorArray.length)]
  }
  let currentUserColor = userColor[sender];

  // Random photo
  if (!userPhoto[message.sender]) {
    userPhoto[message.sender] = imageArray[Math.floor(Math.random() * imageArray.length)]
  }
  let currentUserPhoto = userPhoto[sender];

  let messageDate = new Date(datetime).toLocaleTimeString();

  return `
    <img src="./avatars/${currentUserPhoto}" alt=""/>
    <p>
    <small><strong style='color:${currentUserColor}'>${sender}</strong></small><br/>
    ${message.message}<br/><smal class="message-time">${messageDate}</small></p>`
}

function setButtonDisabled() {
  let btn = document.getElementById('button-sender');
  btn.setAttribute('disabled', true);
}

function setButtonEnable() {
  let btn = document.getElementById('button-sender');
  btn.removeAttribute('disabled');
}

// Login Methods
function setLoginBtnDisabled() {
  let btn = document.getElementById('btn_login');
  btn.setAttribute('disabled', true);
}

function setLoginBtnEnabled() {
  let btn = document.getElementById('btn_login');
  btn.removeAttribute('disabled');
}

function enableChat(user) {
  var logindiv = document.querySelector("#login-div");
  logindiv.classList.add("hidden");
  var nav = document.querySelector("#nav");
  nav.classList.remove("hidden");
  nav.classList.add("show");
  var maindiv = document.querySelector("#maindiv");
  maindiv.classList.remove("hidden");
  maindiv.classList.add("show");

  document.querySelector("#sender").value = user
  document.querySelector("#username").innerHTML = user
  getToken().then(() => {
    setTimeout(() => {
      dmsGetMessage('__last__');
    }, 1000);
  });
}

function makeDateSpan(date) {
  const list = document.querySelector("#message-list");
  var li = document.createElement('li')

  li.setAttribute("class", "date-li")

  list.appendChild(li);
  li.innerHTML = `<span class='date-span'>${date}</span>`;
}

function htmlEntities(str) {
  return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}