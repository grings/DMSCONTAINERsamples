import { EventStreamsRPCProxy } from './eventstreamsrpc.js';

let lastID = '__last__';
let timestamp = getLastHour();
let superToken = "";
let queueNameTest = "chat";
let eventStreamsRPCUrl = appConfig.URL;
let isEmojiOpen = 0;

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
let soundBtn = document.getElementById('sound-btn');
let emojiBtn = document.getElementById('emoji-pick');

let notification = new Audio('audio/notification.mp3');

let today = new Date();
let alredyToday = 0;
let isFirst = 1;

let enableSound = sessionStorage.getItem('sound') != undefined ? sessionStorage.getItem('sound') : true;

emojiBtn.addEventListener("click", function (e) {
  e.preventDefault();
  if (isEmojiOpen === 0) {
    isEmojiOpen = 1;
    var newDiv = document.createElement("div");
    newDiv.setAttribute('id', "emoji-div");
    newDiv.innerHTML = "<emoji-picker></emoji-picker>";

    let emojiDiv = document.getElementById('emoji-modal');
    emojiDiv.appendChild(newDiv);

    document.querySelector('emoji-picker')
      .addEventListener('emoji-click', event => {
        document.getElementById('sender-input').value += event.detail.unicode + " ";
        setButtonEnable();
      });
  } else {
    isEmojiOpen = 0;
    var elem = document.getElementById('emoji-div');
    elem.remove();
  }
})

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

soundBtn.addEventListener("change", function (evt) {
  sessionStorage.setItem('sound', evt.target.checked);
  enableSound = sessionStorage.getItem('sound');
})

document.addEventListener("DOMContentLoaded", function (e) {
  var elems = document.querySelectorAll('.sidenav');
  let options = {
    menuWidth: 300, // Default is 300
    edge: 'left', // Choose the horizontal origin
    closeOnClick: false, // Closes side-nav on <a> clicks, useful for Angular/Meteor
    draggable: true // Choose whether you can drag to open on touch screens
  }
  var instances = M.Sidenav.init(elems, options);

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

  if(appConfig.EMOJI) {
    emojiBtn.classList.remove("hidden");
  }

  // Timeout con chiamata
  // Nel dmsGetMessage, se torna qualcosa che non è timout true, allora rischedula dmsGetMessage
  const form = document.querySelector("#chatForm")
  form.addEventListener("submit", function (e) {
    e.preventDefault();
    if (e.submitter.id !== 'emoji-pick') {
      isEmojiOpen = 0;
      var elem = document.getElementById('emoji-div');
      if(elem) {
        elem.remove();
      }

      postMessage(e.target)
    }
  })

})

function getLastHour() {
  var d = new Date();

  d.setHours(d.getHours() - 1);

  return d.toISOString();
}

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
function dmsGetMessage(lastKnownMsgID,timestamp) {
  let proxy = getProxy();
  // Solo la prima volta deve chiamare il metodo timestamp altrimenti dequeueMessage
  if (isFirst) {
    proxy.getNextMessageByTimestamp(superToken, queueNameTest, timestamp, true)
      .then(function (messages) {
        procedureMessage(messages)
      });
  } else {
    proxy.dequeueMessage(superToken, queueNameTest, lastKnownMsgID, 5)
      .then(function (messages) {
        procedureMessage(messages)
      });
  }
}

function procedureMessage(messages) {
  if (messages.data) {
    messages = messages.data;
  }

  isFirst = 0;
  if (!messages.timeout) {
    renderMessage(messages)
  }
  setTimeout(() => {
    dmsGetMessage(lastID,getLastHour());
  }, 1000);
}

//  Posta messaggi
function postMessage(form) {
  let proxy = getProxy();
  let queueMessageTest = {
    sender: form.sender.value,
    message: htmlEntities(form.message.value),
    chatName: queueNameTest
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

function queueList() {
  let proxy = getProxy();

  proxy.getQueuesInfo(superToken, "chat")
    .then(function (res) {
      // Disegna queue
      const list = document.querySelector("#queue-list");
      const listMobile = document.querySelector("#slide-out");

      res.queue_names.forEach(queue => {
        if (queue.queue_name != 'chat') {

          let visibleName = getChatVisibleName(queue.queue_name)
          // Desktop
          var li = document.createElement('li')

          li.setAttribute("data-id", queue.queue_name)
          li.setAttribute("class", "contact")

          list.appendChild(li);
          li.innerHTML = `<div class="wrap"><div class="meta">${visibleName}</div><div class="hidden-meta">${queue.queue_name}</div></div>`;

          // Mobile anche
          var lim = document.createElement('li')

          lim.setAttribute("data-id", queue.queue_name + '-m')
          lim.setAttribute("class", "contact")

          listMobile.appendChild(lim);
          lim.innerHTML = `<div class="wrap"><div class="meta">${visibleName}</div><div class="hidden-meta">${queue.queue_name}</div></div>`;
        }
      });

    });

}

function renderMessage(message) {
  message = message[0];
  if (lastID != message.messageid && message.message.chatName === queueNameTest) {
    lastID = message.messageid;
    // isFirst = 0;
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
      if (enableSound == 'true') {
        notification.play();
      }
    }

    let msgDate = new Date(message.createdatutc).toDateString();
    if (new Date(today).toDateString() < msgDate) {
      if (today != msgDate) {
        today = msgDate;
        msgDate = new Date(msgDate).toISOString().slice(0, 10).replace(/-/g, "/");
        makeDateSpan(msgDate);
      }
    } else if (!alredyToday) {
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
  // mobile
  document.querySelector("#username-mobile").innerHTML = user

  const cbox = document.querySelector('#sound-btn');
  cbox.checked = (enableSound === 'true');

  const queuelist = document.querySelector("#queue-list");
  const queuelistMobile = document.querySelector("#slide-out");

  // DESKTOP
  queuelist.addEventListener("click", (evt) => {
    
    if (evt.target.tagName === 'DIV') {

      if (queueNameTest != evt.target.innerHTML) {

        alredyToday = 0;
        // DESKTOP
        // Rimozione della classe active al precedente div
        let previousChat = document.querySelector(`[data-id="${queueNameTest}"]`);
        previousChat.classList.remove("active")

        // Impostare la classe active al div scelto
        let currentChat = document.querySelector(`[data-id="${evt.target.innerHTML}"]`);
        currentChat.classList.add("active");
        // END DESKTOP

        // MOBILE
        // Rimozione della classe active al precedente div
        let previousChatM = document.querySelector(`[data-id="${queueNameTest}-m"]`);
        previousChatM.classList.remove("active")

        // Impostare la classe active al div scelto
        let currentChatM = document.querySelector(`[data-id="${evt.target.innerHTML}-m"]`);
        currentChatM.classList.add("active");
        // END MOBILE

        // cancellare la chat corrente dall'html
        queueNameTest = evt.target.innerHTML;
        const list = document.querySelector("#message-list");
        list.innerHTML = "";
        messageList = [];

        // Cambiare il nome della chat corrente
        document.querySelector("#chatname").innerHTML = getChatVisibleName(queueNameTest);

        // Richiere il __last__ della chat richiesta
        isFirst = 1;
        timestamp = getLastHour();
        lastID = '__last__';

      }

    }
  });

  // MOBILE
  queuelistMobile.addEventListener("click", (evt) => {
    if (evt.target.tagName === 'DIV') {

      if (queueNameTest != evt.target.innerHTML) {
        alredyToday = 0;
        // DESKTOP
        // Rimozione della classe active al precedente div
        let previousChat = document.querySelector(`[data-id="${queueNameTest}"]`);
        previousChat.classList.remove("active")

        // Impostare la classe active al div scelto
        let currentChat = document.querySelector(`[data-id="${evt.target.innerHTML}"]`);
        currentChat.classList.add("active");
        // END DESKTOP

        // MOBILE
        // Rimozione della classe active al precedente div
        let previousChatM = document.querySelector(`[data-id="${queueNameTest}-m"]`);
        previousChatM.classList.remove("active")

        // Impostare la classe active al div scelto
        let currentChatM = document.querySelector(`[data-id="${evt.target.innerHTML}-m"]`);
        currentChatM.classList.add("active");
        // END MOBILE

        // cancellare la chat corrente dall'html
        queueNameTest = evt.target.innerHTML;
        const list = document.querySelector("#message-list");
        list.innerHTML = "";
        messageList = [];

        // Cambiare il nome della chat corrente
        document.querySelector("#chatname").innerHTML = getChatVisibleName(queueNameTest);

        // Richiere il __last__ della chat richiesta
        isFirst = 1;
        timestamp = getLastHour();
        lastID = '__last__';

        var instance = M.Sidenav.getInstance(document.querySelectorAll('.sidenav')[0]);
        instance.close();
      }

    }
  });

  getToken().then(() => {
    setTimeout(() => {
      queueList();
      dmsGetMessage(lastID,timestamp);
    }, 1000);
  });
}

function getChatVisibleName(queuename) {
  return queuename.replace('chat.', '');
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