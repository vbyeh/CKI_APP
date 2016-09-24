#CKI APP

INTRODUCTION
============
This 'currently' prototyped application is meant to simplify event transparancy with UC Davis Circle K International Club and its club members. It allows members to sign up, check in, and access club information through mobile. An iOS calendar app where administrators can create events on Google Form and will reflect onto iOS application. Members can then sign up or check in to these events with their personal data collected for club growth analysis. 

Event List:
![alt tag](https://github.com/vbyeh/CKI_APP/blob/master/CKI%20ScreenShots/EventList.png)

Event Info:
![alt tag](https://github.com/vbyeh/CKI_APP/blob/master/CKI%20ScreenShots/EventInfo.png)

Settings:
![alt tag](https://github.com/vbyeh/CKI_APP/blob/master/CKI%20ScreenShots/Settings.png)

Check In/Check Out:
![alt tag](https://github.com/vbyeh/CKI_APP/blob/master/CKI%20ScreenShots/CheckIO.png)

User Guide
==========
When user first open the applcation they will see the most recent 50 events in chrnological order. The top right is a setting icon that allow users to configure settings tailored to their personal preferences or view club specific detail. Each event contains Name, Date, and Time and clicking on the specific row will allow user to access more detail regarding the event such as Location, Description, and other participants. Each event is divided into (Service: lightblue, Leadership: lightgreen, Fellowship: lightpurple). Users can also Check In to events that are currently happening or they can Sign Up for upcoming events. On each event page, clicking participant will allow users to see who has signed up and who has checked in to the event.

Technical Workflow
==================
Beginning with Google Form, the submitted form by administrators are pushed to a designated Google Spreadsheet using Google App Script. AWS NoSQL DyanmoDB then polls the Google Spreadsheet for updates. When user opens their individual iOS device, they are authorized to access DynamoDB table from IAM Cognito unauth role. Their device then queries the first 50 event data from designated DynamoDB table and display them in chrnological order. Upon push actions, they are segue into another UIView specific to the event. User then interacts with UserHandler sign up, which writes information such as name, phone number, email into a specified table for data collection. On check ins, user's time checked in and time checked out are stored for service, leadership, and fellowship hour calculations. 

REQUIREMENTS
============
- AWS frameworks from AWS iOS SDK: AWSAPIGateway.framework, AWSCognito.framework, AWSCore.framework, AWSDynamoDB.framework
- AWS Cognito credentials with specific region and identityPoolId, currently using IAM Cognito_Unauth_Role with AmazonDynamoDBFullAccesswithDataPipeline
- Pipeline between Google Form, Google Spreadsheet, and AWS

Upcoming Features
=================
- Allow users to sign up and have individual information that writes to another DynamoDB table for member data collection
- 'Like' button that allows users to save individual preferences of events into their phone's local memory
- Implement a way for members to see people who are signed up for this event
- User data collection