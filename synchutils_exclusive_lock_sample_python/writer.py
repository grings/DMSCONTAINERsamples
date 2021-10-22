import sys
import os
from os.path import dirname
sys.path.append(dirname(dirname(__file__))) #allows to use commonspy
####
import time
import random
from commonspy.synchutilsproxy import SynchUtilsRPCProxy, SynchUtilsRPCException

if len(sys.argv) != 2:
    raise Exception("Invalid writer's name")
name = sys.argv[1]
proxy = SynchUtilsRPCProxy('https://localhost/synchutilsrpc')
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
                    time.sleep(1 + random.random() * 2)
                    continue
                print("Lock acquired, writing the file...")
                with open("file.log","a") as f:
                    f.write(f"My name is {name:10s}, and I've got the lock identifier {lock_identifier}, my current handle is {lockhandle}\n")
                    time.sleep(0.2 + random.random() * 2)
                print("Done, let's release the lock")
                proxy.release_lock(token, lockhandle)
                lockhandle = ""
                time.sleep(1 + random.random() * 2)
        except SynchUtilsRPCException:
            res = proxy.login("user_admin","pwd1")
            token = res["token"]
except KeyboardInterrupt:
    print("Quit")



