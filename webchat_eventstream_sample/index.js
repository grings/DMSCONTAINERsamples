import {EventStreamsRPCProxy} from './eventstreamsrpc.js';

let lastID = 0;
let superToken = "";
let queueNameTest = "chat";
let eventStreamsRPCUrl = 'https://localhost:443/eventstreamsrpc';

let colorArray = ['#FF6633', '#FFB399', '#FF33FF', '#FFFF99', '#00B3E6', 
		  '#E6B333', '#3366E6', '#999966', '#99FF99', '#B34D4D',
		  '#80B300', '#809900', '#E6B3B3', '#6680B3', '#66991A', 
		  '#FF99E6', '#CCFF1A', '#FF1A66', '#E6331A', '#33FFCC',
		  '#66994D', '#B366CC', '#4D8000', '#B33300', '#CC80CC', 
		  '#66664D', '#991AFF', '#E666FF', '#4DB3FF', '#1AB399',
		  '#E666B3', '#33991A', '#CC9999', '#B3B31A', '#00E680', 
		  '#4D8066', '#809980', '#E6FF80', '#1AFF33', '#999933',
		  '#FF3380', '#CCCC00', '#66E64D', '#4D80CC', '#9900B3', 
		  '#E64D66', '#4DB380', '#FF4D4D', '#99E6E6', '#6666FF'];

let userColor = {};

document.addEventListener("DOMContentLoaded", function(e) {
    // Name can't be blank
    let user = ""
    while (user == "") {
      user = prompt("Please enter your name")
    }
    document.querySelector("#sender").value = user
    document.querySelector("#username").innerHTML = user
    superToken = getToken().then(() => {
      setTimeout(() => {
        dmsGetMessage('__last__');
      }, 1000);
    });
    // Timeout con chiamata
    // Nel dmsGetMessage, se torna qualcosa che non è timout true, allora rischedula dmsGetMessage
    const form = document.querySelector("#chatForm")
    form.addEventListener("submit", function(e) {
      e.preventDefault()
      postMessage(e.target)
    })

  })

  function getProxy() {
    return new EventStreamsRPCProxy(eventStreamsRPCUrl);
  }

  function getToken() {
    let proxy = getProxy();
    return proxy.login('user_admin','pwd1')
    .then(function(res) {
      superToken = res.token;
    });
  }

  //  Prendi messaggi
  function dmsGetMessage(lastKnownMsgID) {
    let proxy = getProxy();
    // Solo la prima volta deve chiedere il last, le altre volte deve chiedere l'id salvato
    proxy.dequeueMessage(superToken, queueNameTest, lastKnownMsgID,5)
    .then(function(messages) {
      if(!messages.timeout) {
        renderMessage(messages)
      }
      setTimeout(() => {
        dmsGetMessage(lastID);
      },1000);
    });
  }
  
  //  Posta messaggi
  function postMessage(form) {
    let proxy = getProxy();
    let queueMessageTest = {
      sender: form.sender.value,
      message: form.message.value
    };
    proxy.enqueueMessage(superToken, queueNameTest, queueMessageTest)
    .then(function() {
      form.message.value = "";
    });
  }

  function renderMessage(message) {
    if(lastID != message.messageid) {
      lastID = message.messageid;
      const list = document.querySelector("#message-list");
      var li= document.createElement('li')
      li.setAttribute("data-id", message.messageid)
      list.appendChild(li);
      li.innerHTML=makeLi(message.message);
      var objDiv = document.getElementById("real-chat");
      objDiv.scrollTop = objDiv.scrollHeight;
    }
  }
  
  function makeLi(message) {
    // Vedere se il sender esiste nel dizionario ed ha un colore associato
    // Se non è associato, aggiunge il sender nel dizionario e gli associa un colore
    // Se è associato allora prende il colore
    if(!userColor[message.sender]) {
      userColor[message.sender] = colorArray[Math.floor(Math.random() * colorArray.length)]
    }
    let currentUserColor = userColor[message.sender]; 

    let sender = document.querySelector("#sender").value
    let classe = "";
    let bubbleClass = "";
    if (message.sender == sender) {
      sender = "You"
      classe = "right-message";
      bubbleClass = "speech-bubble-left";
    } else {
      sender = message.sender
      classe = "left-message";
      bubbleClass = "speech-bubble-right";
    }
    //prettier-ignore
    return `
      <div class='speech-bubble ${bubbleClass} ${classe}'><small><strong style='color:${currentUserColor}'>${sender}</strong></small><p style="margin:0px;">${message.message}</p></div>
      `
  }