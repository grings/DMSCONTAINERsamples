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

in the following sample we can access with various login credentials and various modes of sending messages including:

* Simple messagge with no attachments (TEXT+HTML)
* Simple messagge with no attachments (TEXT Only)
* Message with attachments 
* Send Bulk messagge

with the possibility to visualize in the Get my Messagge section all the messages, and in the Get Pending Messagges section all the pending messages.

There are also other additional tools such as sending RQL messages.



A reference to follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com) or [watch the video tutorials](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/.)


## email_module_tutorial ##
 DmsContainer puts at our disposal the possibility to send emails, the following example shows how various users enabled for various purposes can access this service.

After configuring everything in the ADMINGUi, in the example in question we find the possibility to send messages of various types :

* Send a simple mail 
* send email with attachment 
* send bulk messages 

to test the example, we need to change the email inserted in the attribute of the object lJMsg: TJSONObject in the following way :

>Insert your email test in the 
>```pascal
>
> lJMsg.S['msgtolist'] := 'sample@gmail.com';
>
>```
>for run the sample


A reference to follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com) or [watch the video tutorials](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials/.)

## event_streams_chat ##

In this example we can see that events are used, the test proposes a chat, where messages can be sent within it, an instance is created in the DMSContainer which contains the messages sent by the participants in that instance.


## event_streams_module_tutorial ##
In this example we can see all the qualities of the event streams. 

{{% notice warning%}}
To run the program you need to enable the user_event user by the ADMINGui, and change the `const DMS_SERVER_URL` in case the DMSContainer service is not running locally
{{% /Notice %}}

Here are the features present in the example:
* Create one or more queue
* Send Message
* Send Huge Message 
* Send Message with custom TTL
* Send Multiple Message with custom TTL
* Dequeue Next message
* Dequeue `__first__` message
* Dequeue `__last__` message
* Know last id
* Set Dequeue timeout
* Show Queue size
* Delete Queue

{{% notice note%}}
You can see all messages also in the ADMINGui, by the Events menu
{{% /Notice %}}


## event_streams_producer_consumer ##




## event_streams_sample_worker ##
In this example there is a simple application console that dequeue a Multiple Message from a specific queue (by parameter)

```batch
start EventStreamsWorker user_queue1
```

In the bin folder you can see two example bat file:
* run.bat (show message from multiple queue at the same time)
* runone.bat (read one queue)

## excel_module_sample ##
DmsContainer has the possibility to export data to Excel in many ways.
the following example shows how DmsContainer supports many types of export 

Steps to execute first to run the programm:
1. enabled the user_report account by the ADMINGui
2. run the sample

DMSContainer gives us the possibility to export our data in many ways including :

* Simple Data
* All Data Types
* All Data Types with formatting
* All in one workbook
* Huge workbook 
* Simple JSON
* JSON with formatting
* JSON with formulas 
* Sparkline
* Showcase

## methods_invocation_without_proxies ##

This example shown the possibility to invoke methods without proxies.
In the specific case it is made a login request, where in the memo field is returned an access token (jwt). 


## reports_module_sample ##

this test proposes us a practical example of like being able to exploit the events.

Let's see what other specific ways DMSContainer uses to export data :

* Many Files one customer per file 
* One File, all customers in one file
* Tabular report
* HTML tabuler report
* One File, all customers in one HTML file
* Generate report for 
* Invoces
* Filter Sample 
* Offline Invoces

moreover the example shows us a practical scenario where to use the events, in the section Async Report we can test how to export data in background.

## reports_module_users_to_notify_sample ##

this example proposes us a practical example of like being able to exploit the events, the following test carries out in vare modality of the reports, moreover in the section Async Report the events in order to be able to draw up report in background, but with the addition of the notification of completion to the user previously selected in the list. 


## sso_configuration_provider ##

in this example we see how the SSO module is exploited to enable multiple users to the same context, and how to modify the same only for some and leave it unchanged for others.


## sso_module_sample ##
These examples proposes us a practical guide of SSO module 

There are two app, that use two different context,  `APP1` and `APP2`.

App1 is a simple example that shows the possibility to login and logout only for the users who have associated APP1 contexts. 
Here can see some data of the system_data in read-only .


The App2 example simulates the management of user preferences.
Only users who have the APP2 context can access, and these will be shown their preferences, read from the `user_data`.
These preferences can be changed, while those of the `system_data` are read-only.


>All these values can be seen and modified by `ADMINGui`

{{% notice note%}}
You need to create two contexts APP1 and APP2 by the ADMINGui 
{{% notice%}}


## tictactoe_eventstream_sample ##
This example demonstrates, through the classic game TicTacToe, the multiplicity of uses of the EventStream, using, in this case, the JavaScript version of the EventStreamsRPCProxy proxy.

{{% notice important%}}
You need python for this example.
{{% notice %}}

Here are the steps to play:
1. Open a cli at the level of the example folder 
2. run 
```batch 
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
```batch 
start_server.bat 
```
5. Open two web pages at url http://localhost:8000
6. Insert the user name in each
7. Write or send some emoticon to your new friend

{{% notice note%}}
You can see all the sended message, in the menu "Events" of the Admin Gui 
{{% notice%}}	