# Readme
QuickStartSamplesGroup contains three samples to show the three kind of project that
can be created for DMSContainer

## JobClass without RPCClass:
This combination configures just a job without the RPC interface,
there are no way to interact with the job remotely.

## RPCClass without JobClass:
This combination configures just an RPC endpoint,
there isn’t a running job scheduled.

## JobClass + RPCClass:
This combination is the best from the both: a running job + an RPC interface
to interact remotely with the job.
