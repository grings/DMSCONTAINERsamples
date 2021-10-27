import sys
import os
from os.path import dirname
sys.path.append(dirname(dirname(__file__))) #allows to use commonspy
####
import time
import random
from commonspy.synchutilsproxy import SynchUtilsRPCProxy, SynchUtilsRPCException
from commonspy.eventstreamsproxy import EventStreamsRPCProxy, EventStreamsRPCException

if len(sys.argv) != 2:
    raise Exception("Invalid writer's name")
name = sys.argv[1]
proxy = SynchUtilsRPCProxy('https://localhost/synchutilsrpc')
esproxy = EventStreamsRPCProxy('https://localhost/eventstreamsrpc')
res = proxy.login("user_admin","pwd1")
token = res["token"]
print(f"My name is {name}")
print("Using " + res['dmscontainerversion'])

lock_identifier = "fileres1"
try:
    while True:
        try:
            while True:
                lockhandle = proxy.try_acquire_lock(token, lock_identifier, 20, {})    
                if lockhandle == 'error': 
                    print("Cannot acquire the lock... let's wait...")
                    queue = proxy.get_exclusive_lock_queue_name(token, lock_identifier)                    
                    lkid = "__last__"
                    while True:
                        print("Waiting for the lock_released event...")
                        res = esproxy.dequeue_message(token, queue, lkid, 30)
                        if not 'timeout' in res:                            
                            msg = res['data'][-1]
                            if msg['message']['action'] == 'lock_released':
                                break
                            lkid = msg['messageid']                        
                    continue
                print("Lock acquired, writing the file...")
                with open("file.log","a") as f:
                    f.write(f"My name is {name:10s}, and I've got the lock identifier {lock_identifier}, my current handle is {lockhandle}\n")
                    time.sleep(0.2 + random.random() * 2)
                print("Done, let's release the lock")
                proxy.release_lock(token, lockhandle)
                lockhandle = ""
                time.sleep(2 + random.random() * 3)
        except SynchUtilsRPCException:
            res = proxy.login("user_admin","pwd1")
            token = res["token"]
except KeyboardInterrupt:
    print("Quit")



