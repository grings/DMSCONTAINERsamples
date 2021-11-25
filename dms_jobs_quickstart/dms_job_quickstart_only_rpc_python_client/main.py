from dms_job_quickstart_only_rpc_proxy import JobQuickStart1RPCProxy, JobQuickStart1RPCException

proxy = JobQuickStart1RPCProxy("https://localhost/jobquickstart1rpc")
# method "echo" doesn't require authentication
reversed_string = proxy.echo("Hello World")
print(reversed_string) # prints "dlroW olleH"
