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
*  Download and Add DelphiMVCFramework to your Delphi Library Path:
  - you can download it at the following [link] (https://github.com/danieleteti/delphimvcframework)
  - Add these folder with your Delphi IDE (tools => options => Delphi => languages => Path): 
	* sources
	* lib\dmustache
	* lib\loggerpro
	* lib\swagdoc\Source 
    

### Examples 

* A brief description of the examples follows


## api_key_sample ##

#### what's the use? ####  

Api keys sample shows us how DMSContainer gives the possibility to use jwt authentication without necessarily making a login.

You can generate a unique api key for some user, by the AdminGUI, and using that token can make any requests and access various services for example (export data to excel).

this test proposes two pdf export options:

* with the 1st Tab button we can export the data present in the grid to an excel file (data displayed in the grid are in a json file `customers.json` saved in the folder `DMScontainersamples\data`) 

* with the raw json button we export the data in a json input( already present in the const `JSON` ) to an excel file.

Read the [User API Key Management](http://dmscontainer.bittimeprofessionals.com/dmsadmingui/usersmanagement/#create-manage-api-key) documentation for more information.


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

For more information, I recommend that you follow the [official DMSContainer documentation](http://dmscontainer.bittimeprofessionals.com)
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)

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
Like the 2?? example in these, you can try the power of custom jobs (RPC or only scheduled) 

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

* button  `Simple messagge with no attachments "text+html"` (sends an email with simple text or html in it, with no attachments)

* button  `Simple messagge with no attachments "text only" `(sends an email with simple text only, with no attachments)

* button `Message with attachments` (send an email with attachments) 

* button `Send Bulk messagge` (Send a large number of messages in a short period of time, or to a large number of recipients)

with the possibility to visualize in the Get my Messagge section all the messages, and in the Get Pending Messagges section all the pending messages.

There are also other additional tools such as sending RQL messages.


Read the [Email Module](http://dmscontainer.bittimeprofessionals.com/builtinjobs/emailmodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)



## email_module_tutorial ##
 DmsContainer puts at our disposal the possibility to send emails, the following example shows how various users enabled for various purposes can access this service.

After configuring everything in the ADMINGUi, in the example in question we find the possibility to send messages of various types :

* button `send a simple mail` (send an email with simple text or html in it, with no attachments)
* button  `send email with attachment` (send an email with attachments) 
* button  `send bulk messages` (send a large number of messages in a short period of time, or to a large number of recipients)


to test the example, we need to change the email inserted in the attribute of the object `lJMsg` in the following way :

>Insert your email test in the 
>```pascal
>
> lJMsg.S['msgtolist'] := 'sample@gmail.com';
>
>```
>for run the sample

Read the [Email Module](http://dmscontainer.bittimeprofessionals.com/builtinjobs/emailmodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)


## event_streams_chat ##

In this example we can see that events are used, the test proposes a chat, where messages can be sent within it, an instance is created in the DMSContainer which contains the messages sent by the participants in that instance.


## event_streams_module_tutorial ##
In this example we can see all the qualities of the event streams. 

{{% notice warning%}}
To run the program you need to enable the user_event user by the ADMINGui, and change the `const DMS_SERVER_URL` in case the DMSContainer service is not running locally
{{% /Notice %}}

The components in the main form are:
* Edit with label "Queue Name" => write here the queue name (default queue.test1)
* Edit with label "Last Know ID" => there is the last ID read by the dequeue
* Button with caption "Dequeue __first__ Message" => call the method for dequeue the first message of the queue 
* Button with caption "Dequeue __last__ Message" => call the method for dequeue the last message of the queue 
* Button with caption "Dequeue Next Message" => call the method for dequeue the next message of the queue 
* Check box "Update LKID" => if check the last id read from the queue will saved in the edit "Last Know ID"
* Edit with label "Dequeue Timeout" => there is the timeout for the dequeu, in seconds (default 10)
* Button with caption "Delete Queue" => delete the queue with the name write in the Edit "Queue Name"
* Button with caption "Queue Size" => write in the memo the size of the queue
* Memo "Logs" => read here all the dequeue message from the queue write in the Edit "Queue Name"
* Group Box "Single Message"
	* Edit with caption "Message Value" => write here the message that you want send (default 1 and auto increment)
	* Button with caption "Send Message" => send the message
* Group Box "Single Huge Message"
	* Button with caption "Send Huge Message" => send an hard coded message of huge dimension
* Group Box "Messages with TTL" (Time To Live)
	* Edit with caption "TTL (min)" => the value expressed in minute of the Time To Live (TTL) of message (default 1)
	* Button with caption "Send Single Message" => send a Message, write in the edit "Message Value", with a TTL defined in the edit "TTL"
	* Button with caption "Send Multiple Messages" => send 10 Messages, with a TTL defined in the edit "TTL", in a queue named "queue.sample"


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

Read the [Event Streams](http://dmscontainer.bittimeprofessionals.com/builtinjobs/eventstreams/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)


## event_streams_producer_consumer ##

In this example we can demostrate the speed of DMSContainer to dequeue the messange by EventStream.
There are 3 project:

** EventStreamsProducer **
He do create messages in a queue.

The components in the main form are:
* an edit where put the name of the queue to can write (default queue.test1)
* a memo where insert the message (in JSON format) to send (default {"name": "Value"})
* button with caption "Delete Queue" => delete the queue
* button with caption "X 100" => starts a task with 100 messages
* button with caption "X 10" => starts a task with 10 messages
* button with caption "X 1" => starts a task with only 1 message
* label with the number of running tasks

** EventStreamsConsumer **
It does the dequeu of a queue

The components present in the main form are:
* an edit where put the name of the queue to can read (default queue.test1)
* a button to start or stop reading
* a memo where he writes the messages arriving from that queue

** Event_stream_monitor **
Demonstrate the speed of dequeue

The form contains a grid with 48 cells that each represent a consumer

They will show the number of messages that the consumer has read

By sending a series of messages through the producer you will be able to notice the speed with which these are dequeued

Read the [Event Streams](http://dmscontainer.bittimeprofessionals.com/builtinjobs/eventstreams/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)


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

* button "Simple Data" (can export in excel simple date without currencies and special characters)
* button  "All Data Types" (can export in excel all types of data without formatting the file)
* button  "All Data Types with formatting" (can export in excel all types of data with formatting the file)

* button  "All in one workbook" (can export in excel worbook and saving the data in various sheets respectively divided by Customers, All Types, All Types with Formatting, inside you will find the same data seen in the previous examples all enclosed in a single file.)

* button  "Huge workbook" (provides a huge data in excel)

* button  "Simple JSON" (takes a json input and exports it to excel without formatting it)

* button "JSON with formatting" (takes a json input and exports it to excel and formats it)

* button  "JSON with formulas" (can export in excel a json file containing mathematical formulas, in this case "SUM", and restore them in the exported file)

* button "Sparkline" (can  exports in excel the required data with sparkline representation, small graph representing the trend of something)

* button  "Showcase" (exports in excel the required data with Showcase representation, for example underlined values in another color)

Read the [Excel Module](http://dmscontainer.bittimeprofessionals.com/builtinjobs/excelmodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)



## methods_invocation_without_proxies ##

This example shown the possibility to invoke methods without proxies.
In the specific case it is made a login request, where in the memo fieinvoices ld is returned an access token (jwt). 


## reports_module_sample ##

this test proposes us a practical example of like being able to exploit the events.

Let's see what other specific ways DMSContainer uses to export data :

* button `Many Files, one customer per file` (exports as many pdf files as there are customers )
* button `One File, all customers in one file` (exports a pdf file with all customers inside )
* button `Tabular report` (generates a tabular pdf with all customers)
* button `HTML tabuler report` (generates a tabular HTML with all customers)
* button `One File, all customers in one HTML file` (generates an html file with all 'inside all the information divided by individual customer on a single file)
* button `Generate report for 1500 customer` (generate 100 reports and then create a zipper file with all the files)
* button ` Invoces` (exports the detail of an invoice)
* button `Filter Sample` (export of various filter examples) 
* button `Offline Invoces` (export of unpaid invoices )

moreover the example shows us a practical scenario where to use the events, in the section Async Report we can test how to export data in background.

Read the [Report Module](http://dmscontainer.bittimeprofessionals.com/builtinjobs/reportmodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)



## reports_module_users_to_notify_sample ##

this example proposes us a practical example of like being able to exploit the events, the following test carries out in vare modality of the reports, moreover in the section Async Report the events in order to be able to draw up report in background, but with the addition of the notification of completion to the user previously selected in the list. 

Read the [Report Module](http://dmscontainer.bittimeprofessionals.com/builtinjobs/reportmodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)


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

Read the [SINGLE-SIGN-ON MODULE](http://dmscontainer.bittimeprofessionals.com/builtinjobs/ssomodule/) documentation for more information
or 
[watch the videos in the Tutorial section](http://dmscontainer.bittimeprofessionals.com/tutorials/video_tutorials)


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