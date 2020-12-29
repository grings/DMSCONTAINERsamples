import time
from common import get_eventstreams_proxy, base_url_eventstreams, username, password

from eventstreamsproxy import EventStreamsRPCProxy, EventStreamsRPCException

def esproxy():
    return EventStreamsRPCProxy(base_url_eventstreams)

def game_matcher(esproxy):
    waiting_users = [];
    tkn = esproxy.login(username, password).get("token")
    messageid = '__last__'
    while True:
        msg = esproxy.dequeue_multiple_message(tkn, "ticketQueue", messageid, 1, 5)
        if not msg.get("timeout"):
            print(msg["data"][0]["message"]);
            messageid = msg["data"][0]["messageid"]

            # Fare un check se l'utente appena entrato già esiste nella lista
            waiting_users.append(msg["data"][0]["message"])

            # Forse questa funzionalità può essere spostata fuori
            while(len(waiting_users) > 1):
                print("Accoppio le due persone: "+ waiting_users[0]["username"] + " e " + waiting_users[1]["username"])

                print("Creo la nuova coda")
                playqueue = waiting_users[0]["username"]+waiting_users[1]["username"]
                print("La coda è tictactoe."+playqueue)

                print("Avverto l'utente " + waiting_users[0]["username"] + " che il gioco sta per iniziare")
                give_ticket_to_player(esproxy,waiting_users[0]["replyqueue"],playqueue)

                print("Avverto l'utente " + waiting_users[1]["username"] + " che il gioco sta per iniziare")
                give_ticket_to_player(esproxy,waiting_users[1]["replyqueue"],playqueue)

                print("Rimuovo gli utenti dalla ticketqueue")
                waiting_users.pop(0)
                waiting_users.pop(0)
                print(waiting_users)

def give_ticket_to_player(esproxy,queue_name,playqueue):
    tkn = esproxy.login(username, password).get("token")
    r = esproxy.enqueue_message(tkn, queue_name, {"message": "A New game is starting!", "playqueue":playqueue})
    # print(r)

game_matcher(esproxy())