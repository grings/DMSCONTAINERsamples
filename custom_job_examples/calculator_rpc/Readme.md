# Readme

# CalculatorProjectGroup

This project group contains two project: dms_job_calculator.bpl and calculator_vcl_client.exe.

## dms_job_calculator.bpl
In this project we create a JSON-RPC Class publishing two calculation functions: SUM and DIFF.
Jobs.Calculator.RPC.pas is the unit that defines a class, TCalculatorRPC, deirved from TCustomRPC base class; this class
exposes via RPC two methods: SUM and DIFF.
Building the project, we can obtain a .bpl and configure it in DMSContainer, via jobsmanager.json

## calculator_vcl_client.exe
It is a client application that, defining a proxy and using a TMVCJSONRPCExecutor, invokes the SUM e DIFF functions as
DMSContainer services.
