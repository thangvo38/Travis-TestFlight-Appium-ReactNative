# Call Kobiton REST API to get session information
This part will demonstrate how to get session information with Kobiton rest api. 
>Note: Kobiton have supported multiple language for [API documentation](add_api_doc_url). Go to docs for further language support

## Prerequisites
- Kobiton username.
- Kobiton API key.

## 1. Authentication
To make a request:
- Encode your credentials in base64 for HTTP Basic Authenitication. You can run this command below to get the encoded token:  
`echo -n <your_username>:<your_api_key>`


## 2. Get session information through Kobiton REST API
- To send API request:
~~~
curl -X GET https://api.kobiton.com/v1/{request_path}
-H 'Authorization: Basic dGVzdHVzZXI6MTIzZWQtMTIzZmFjLTkxMzdkY2E='
-H 'Accept: application/json'
~~~

### 2.1 Get Application Info
`GET /apps/{application_ID}`
You can get your application id in your desiredCaps.

### 2.2 Get Session Info
`GET /session/{sessionID}`

Response elements:
- `state`: Test final result
- `deviceBooked`: Check if the device is booked
- `log`: The log URL and video URL  
* Log url and video url might take a while to be uploaded to Kobtion Portal. Therefore, you will have to wait before getting your session information.

For more information, check [Kobiton API Document](https://api.kobiton.com/docs/?javascript--nodejs#get-a-session)  

### 2.3 Get Session Commands
`GET /session/{sessionId}/commands`

To get a certain page of your commands, add `page` parameter in your query.  
  
For example:
`GET /session/{sessionId}/commands?page=2`

## 3. Final result
The test is either a success or failure.  
**Failure Case**  
* **Device is already booked, please select another device.**  
This means your device is already being used. You may either select another device or turn off the booked one.  
* **Other**  
Contact Kobiton for more support.

-----
Kobiton API documentation: [https://api.kobiton.com/docs](https://api.kobiton.com/docs)



