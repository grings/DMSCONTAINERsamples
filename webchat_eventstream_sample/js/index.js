import { EventStreamsRPCProxy } from './eventstreamsrpc.js';

let lastID = 0;
let superToken = "";
let queueNameTest = "chat";
let eventStreamsRPCUrl = 'https://localhost:443/eventstreamsrpc';

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

inputElt.addEventListener("input", function () {
  if (this.value == '') {
    setButtonDisabled();
  } else {
    setButtonEnable();
  }
})

document.addEventListener("DOMContentLoaded", function (e) {
  let user = ""

  // Recupare i dati dal sessionStorage
  user = sessionStorage.getItem('chatuser');
  console.log("chatuser", user)

  while (user == "" || user == null) {
    // Name can't be blank
    user = prompt("Please enter your name")
    // Salva i dati nel sessionStorage
    sessionStorage.setItem('chatuser', user);
  }
  document.querySelector("#sender").value = user
  document.querySelector("#username").innerHTML = user
  getToken().then(() => {
    setTimeout(() => {
      dmsGetMessage('__last__');
    }, 1000);
  });
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
  return proxy.login('user_admin', 'pwd1')
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
    message: form.message.value
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
    }
    li.setAttribute("data-id", message.messageid)
    li.setAttribute("class", classe)

    list.appendChild(li);
    li.innerHTML = makeLi(message.message, sender);

    limitMessageSize();

    var objDiv = document.getElementById("real-chat");
    objDiv.scrollTop = objDiv.scrollHeight;
  }
}

function makeLi(message, sender) {
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

  return `
    <img src="./avatars/${currentUserPhoto}" alt=""/>
    <p>
    <small><strong style='color:${currentUserColor}'>${sender}</strong></small><br/>
    ${message.message}</p>`
}

function setButtonDisabled() {
  let btn = document.getElementById('button-sender');
  btn.setAttribute('disabled', true);
}

function setButtonEnable() {
  let btn = document.getElementById('button-sender');
  btn.removeAttribute('disabled');
}