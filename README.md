# DMSContainer Official Samples

![](https://img.shields.io/badge/DMSContainer-Microservices%20made%20simpler-blue) ![](https://img.shields.io/badge/DMSContainer%20Samples%20License-Apache%202.0-green)

This repository contains all the officially supported samples used by [bit Time Professionals](http://www.bittimeprofessionals.it) teachers during the advanced DMSContainer trainings.

### What is this repository for?

* In class exercises
* Self training and private test
* See how the things actually works in DMSContainer
* A reference to follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com)

### How do I get set up? ###

* Just clone the repository and you can use the samples on your running DMSContainer instance
* If you want to try the power of DMSContainer [ask for a free trial licence](mailto:professionals@bittime.it?subject=Free%20DMSContainer%20Trial%20License)



### Examples 

* A brief description of the examples follows


## api_key_sample ##

#### what's the use? ####  
Api keys sample shows us how DMSContainer gives the possibility to use jwt authentication without necessarily making a login.

You can generate a unique api key for some user, by the AdminGUI, and using that token can make any requests and access various services for example (export data to excel)

Read the `User API Key Management` documentation for more information http://dmscontainer.bittimeprofessionals.com/dmsadmingui/usersmanagement/#create-manage-api-key


By starting the program and selecting 1St Tab an excel file will be generated containing the data present in the grid.

>Insert your new API KEY in the 
>```pascal
>const
>  DMS_API_KEY =
>
>```
>for run the sample



## custom_job_examples ##
This example is intended to demonstrate the possibility of creating a custom job and using it in DMSContainer.

For more information, I recommend that you follow the `official DMSContainer documentation` http://dmscontainer.bittimeprofessionals.com 
or 
`watch the videos in the Tutorial section` http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/

#### Step to start the example `calculator_rpc`:
1. Stop the DMSContainer service
2. Build the `dms_job_calculator.bpl` (a `dms_job_calculator.bpl` will be create in the `jobspackage` folder of your DMSContainer installation)
3. Open the jobsmanager.json in the conf folder of your DMSContainer installation
4. Set to `enabled: true` the `jobname: "calculator"`
5. Start the DMSContainer service
6. Run the project `calculator_vcl_client.exe`
7. Cick the button and see the sum result


#### Step to start the example `beeper_job`:
1. Stop the DMSContainer service
2. Build the `dms_job_beeper103.bpl` (a `dms_job_beeper103.bpl` will be create in the `jobspackage` folder of your DMSContainer installation)
3. Open the jobsmanager.json in the conf folder of your DMSContainer installation
4. Set to `enabled: true` the `jobname: "beeper"`
5. Start the DMSContainer service
6. Now yuo can listen a windows beep and can read a log in the `dms_00.beeper.log file`


## dms_jobs_quickstart ##
Like the 2° example in these, you can try the power of custom jobs (RPC or only scheduled) 

Also here, I recommend that you follow the `official DMSContainer documentation` http://dmscontainer.bittimeprofessionals.com 
or 
`watch the videos in the Tutorial section` http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/


## dms_jobs_quickstart ##
Like the 2° example in these, you can try the power of custom jobs (RPC or only scheduled) 

Also here, I recommend that you follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com)
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/)


## email_module_sample ##
One of build-in module in DMSContainer, is Email Module.
the following example shows the power of this module, and the semplicity to use this.

Steps to execute first to run the programm:
1. enabled the user_sender account by the ADMINGui
2. set the user SMTP setting 

for more information [read the documentation](http://dmscontainer.bittimeprofessionals.com/dmsadmingui/usersmanagement)

inserire una  breve spiegazione delle funzionalità presenti nell'esempio

A reference to follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com) or [watch the video tutorials](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/.)


## email_module_tutorial ##
 DmsContainer puts at our disposal the possibility to send emails, the following example shows how various users enabled for various purposes can access this service.
to start the program we have to enable the various users (user_sender etc...) on the Dmscontainer platform in the section USER => ACTION, and configure the mail sender.
A reference to follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com) or [watch the video tutorials](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/.)

## event_streams_chat ##

In this example we can see that events are used, the test proposes a chat, where messages can be sent within it, an instance is created in the DMSContainer which contains the messages sent by the participants in that instance.


## event_streams_module_tutorial ##




## event_streams_producer_consumer ##





## event_streams_sample_worker ##





## excel_module_sample ##
* DmsContainer has the possibility to export data to Excel in many ways.
* the following example shows how DmsContainer supports many types of export (all types of data, all formating data, Huge and All in one Workbook data, showercase, Json etc...).
* First of all, we enable the various accounts in DMScontainer according to the export request, then we can choose the export options.


## methods_invocation_without_proxies ##

This example shown the possibility to invoke methods without proxies.
In the specific case it is made a login request, where in the memo field is returned an access token (jwt). 



## reports_module_sample ##

this example proposes us a practical example of like being able to exploit the events, the following test carries out in vare modality of the reports, moreover in the section Async Report the events in order to be able to draw up report in background


## reports_module_users_to_notify_sample ##

this example proposes us a practical example of like being able to exploit the events, the following test carries out in vare modality of the reports, moreover in the section Async Report the events in order to be able to draw up report in background, but with the addition of the notification of completion to the user previously selected in the list. 



## sso_configuration_provider ##

in this example we see how the SSO module is exploited to enable multiple users to the same context, and how to modify the same only for some and leave it unchanged for others.



## sso_module_sample ##


## tictactoe_eventstream_sample ##
This example demonstrates, through the classic game TicTacToe, the multiplicity of uses of the EventStream, using, in this case, the JavaScript version of the EventStreamsRPCProxy proxy.

>Important You need python for this example.

Here are the steps to play:
1. Open a cli at the level of the example folder 
2. run 
```cmd 
start_server.bat 
```
3. Open a cli at the level of the folder "matcher_client" 
4. run 
```python 
python gameMatcher.py
```
5. Open two web pages at url http://localhost:8000
6. Insert the player's name in each
7. Wait for an opponent
8. When is your turn... make your move


## webchat_eventstream_sample ##
This is a classic chat example.
This chat use the JavaScript version of the EventStreamsRPCProxy proxy.

Here are the steps to play:
1. Open a cli at the level of the example folder 
2. run 
```cmd 
start_server.bat 
```
5. Open two web pages at url http://localhost:8000
6. Insert the user name in each
7. Write or send some emoticon to your new friend

> You can see all the sended message, in the menu "Events" of the Admin Gui 
	