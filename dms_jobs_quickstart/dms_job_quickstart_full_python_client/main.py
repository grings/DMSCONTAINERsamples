from dms_job_quickstart_full_proxy import JobQuickStart3RPCProxy, JobQuickStart3RPCException

proxy = JobQuickStart3RPCProxy("https://localhost/jobquickstart3rpc")
# method "reverse" doesn't require authentication
reversed_string = proxy.reverse("Hello World")
print(reversed_string) # prints "dlroW olleH"
try:
    # we'll get an exception because get_private_data requires a valid token
    proxy.get_private_data("not_a_token")
except JobQuickStart3RPCException as e:    
    print("Bad guy! You have to login first!")

token = proxy.login("user_admin", "pwd1").get("token")
print(token)
private_data = proxy.get_private_data(token)
print(private_data)


