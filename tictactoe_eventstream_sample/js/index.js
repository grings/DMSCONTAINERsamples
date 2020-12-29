import { EventStreamsRPCProxy } from './eventstreamsrpc.js';

let eventStreamsRPCUrl = appConfig.URL;
let superToken = "";
let lastID = '__last__';
let queueName = 'tictactoe.game5';

document.addEventListener("DOMContentLoaded", function (e) {
  getToken().then(() => {
    setTimeout(() => {
      dmsGetMessage(lastID);
    }, 1000);
  });

})

//  Prendi messaggi
function dmsGetMessage(lastKnownMsgID) {
  let proxy = getProxy();
  proxy.dequeueMessage(superToken, queueName, lastKnownMsgID, 5)
    .then(function (message) {
      procedureMessage(message)
    });
}

function procedureMessage(messages) {
  if (messages.data) {
    messages = messages.data[0];
  }

  if (!messages.timeout) {
    console.log("messages", messages);
    if (messages.message.player == currentPlayer) {
      let cell = document.getElementById("cell-" + messages.message.moveIndex);
      handleCellPlayed(cell, messages.message.moveIndex, messages.message.player);
      handleResultValidation();
    }
  }
  setTimeout(() => {
    dmsGetMessage(lastID);
  }, 1000);
}

//  Posta messaggi
function postMessage(moveIndex, player) {
  let proxy = getProxy();
  let queueMessage = {
    player: player,
    moveIndex: moveIndex
  };
  proxy.enqueueMessage(superToken, queueName, queueMessage)
    .then(function () {
      console.log("Game state changed!");
    });
}

/*
We store our game status element here to allow us to more easily 
use it later on 
*/
const statusDisplay = document.querySelector('.game--status');
/*
Here we declare some variables that we will use to track the 
game state throught the game. 
*/
/*
We will use gameActive to pause the game in case of an end scenario
*/
let gameActive = true;
/*
We will store our current player here, so we know whos turn 
*/
let currentPlayer = "X";
/*
We will store our current game state here, the form of empty strings in an array
 will allow us to easily track played cells and validate the game state later on
*/
let gameState = ["", "", "", "", "", "", "", "", ""];
/*
Here we have declared some messages we will display to the user during the game.
Since we have some dynamic factors in those messages, namely the current player,
we have declared them as functions, so that the actual message gets created with 
current data every time we need it.
*/
const winningMessage = () => `Player ${currentPlayer} has won!`;
const drawMessage = () => `Game ended in a draw!`;
const currentPlayerTurn = () => `It's ${currentPlayer}'s turn`;
/*
We set the inital message to let the players know whose turn it is
*/
statusDisplay.innerHTML = currentPlayerTurn();
function handleCellPlayed(clickedCell, clickedCellIndex, player) {
  /*
  We update our internal game state to reflect the played move, 
  as well as update the user interface to reflect the played move
  */
  gameState[clickedCellIndex] = player;
  clickedCell.innerHTML = player;
}

function handlePlayerChange() {
  currentPlayer = currentPlayer === "X" ? "O" : "X";
  statusDisplay.innerHTML = currentPlayerTurn();
}
const winningConditions = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
];

function handleResultValidation() {
  let roundWon = false;
  for (let i = 0; i <= 7; i++) {
    const winCondition = winningConditions[i];
    let a = gameState[winCondition[0]];
    let b = gameState[winCondition[1]];
    let c = gameState[winCondition[2]];
    if (a === '' || b === '' || c === '') {
      continue;
    }
    if (a === b && b === c) {
      roundWon = true;
      break
    }
  }
  if (roundWon) {
    statusDisplay.innerHTML = winningMessage();
    gameActive = false;
    return;
  }
  /* 
  We will check weather there are any values in our game state array 
  that are still not populated with a player sign
  */
  let roundDraw = !gameState.includes("");
  if (roundDraw) {
    statusDisplay.innerHTML = drawMessage();
    gameActive = false;
    return;
  }
  /*
  If we get to here we know that the no one won the game yet, 
  and that there are still moves to be played, so we continue by changing the current player.
  */
  handlePlayerChange();
}

function handleCellClick(clickedCellEvent) {
  /*
  We will save the clicked html element in a variable for easier further use
  */
  const clickedCell = clickedCellEvent.target;
  /*
  Here we will grab the 'data-cell-index' attribute from the clicked cell to identify where that cell is in our grid. 
  Please note that the getAttribute will return a string value. Since we need an actual number we will parse it to an 
  integer(number)
  */
  const clickedCellIndex = parseInt(
    clickedCell.getAttribute('data-cell-index')
  );
  /* 
  Next up we need to check whether the call has already been played, 
  or if the game is paused. If either of those is true we will simply ignore the click.
  */
  if (gameState[clickedCellIndex] !== "" || !gameActive) {
    return;
  }
  /* 
  If everything if in order we will proceed with the game flow
  */
  // handleCellPlayed(clickedCell, clickedCellIndex);
  // handleResultValidation();

  // POST MESSAGE
  postMessage(clickedCellIndex, currentPlayer);
}

function handleRestartGame() {
  let proxy = getProxy();
  proxy.deleteQueue(superToken, queueName)
    .then(function () {
      gameActive = true;
      currentPlayer = "X";
      gameState = ["", "", "", "", "", "", "", "", ""];
      statusDisplay.innerHTML = currentPlayerTurn();
      document.querySelectorAll('.cell')
        .forEach(cell => cell.innerHTML = "");
    });
}
/*
And finally we add our event listeners to the actual game cells, as well as our 
restart button
*/
document.querySelectorAll('.cell').forEach(cell => cell.addEventListener('click', handleCellClick));
document.querySelector('.game--restart').addEventListener('click', handleRestartGame);

function getProxy() {
  return new EventStreamsRPCProxy(eventStreamsRPCUrl);
}

function getToken() {
  let proxy = getProxy();
  return proxy.login(appConfig.USER, appConfig.PWD)
    .then(function (res) {
      superToken = res.token;
    });
}

function htmlEntities(str) {
  return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}