import time
import random
from common import get_eventstreams_proxy, base_url_eventstreams, username, password

from eventstreamsproxy import EventStreamsRPCProxy, EventStreamsRPCException

def esproxy():
    return EventStreamsRPCProxy(base_url_eventstreams)

def game_matcher(esproxy):
    waiting_users = [];
    tkn = esproxy.login(username, password).get("token")
    messageid = '__last__'
    while True:
        msg = esproxy.dequeue_multiple_message(tkn, "ticketQueue", messageid, 1, 10)
        if not msg.get("timeout"):
            print(msg["data"][0]["message"]);
            messageid = msg["data"][0]["messageid"]

            # Fare un check se l'utente appena entrato già esiste nella lista
            waiting_users.append(msg["data"][0]["message"])

            # Forse questa funzionalità può essere spostata fuori
            while(len(waiting_users) > 1):
                print("Accoppio le due persone: "+ waiting_users[0]["username"] + " e " + waiting_users[1]["username"])

                print("Creo la nuova coda")
                # random.guid
                playqueue = "tictactoe."+waiting_users[0]["username"]+waiting_users[1]["username"]
                print("La coda è "+playqueue)

                # Scelgo chi è X e chi è O
                players = ["X","O"]

                print("Avverto l'utente " + waiting_users[0]["username"] + " che il gioco sta per iniziare")
                give_ticket_to_player(esproxy,waiting_users[0]["replyqueue"],playqueue,players[0])

                print("Avverto l'utente " + waiting_users[1]["username"] + " che il gioco sta per iniziare")
                give_ticket_to_player(esproxy,waiting_users[1]["replyqueue"],playqueue,players[1])

                # start_match(esproxy,waiting_users[1]["replyqueue"],playqueue,players[1])

                print("Rimuovo gli utenti dalla ticketqueue")
                waiting_users.pop(0)
                waiting_users.pop(0)
                print(waiting_users)

def give_ticket_to_player(esproxy,queue_name,playqueue,playertype):
    tkn = esproxy.login(username, password).get("token")
    # info dell'opponent da mandare
    r = esproxy.enqueue_message(tkn, queue_name, {"message": "A New game is starting!", "playqueue":playqueue, "playertype":playertype})
    # print(r)

# Scrive direttamente due messaggi invece di uno alla volta
def start_match(playqueue,players):
    tkn = esproxy.login(username, password).get("token")
    message = {"message": "A New game is starting!", "playqueue":playqueue, "playertype":""};
    messages = [message,message]
    messages[0]["playertype"] = "X";
    messages[1]["playertype"] = "O";
    # info dell'opponent da mandare
    # r = esproxy.EnqueueMultipleMessages(tkn, queue_name, )
    

game_matcher(esproxy())