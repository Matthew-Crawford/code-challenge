# README

This experience has been interesting and fun. I've never really worked with rails and found myself very rusty with 
ruby so I effectively learned a new language and framework through this exercise. I'll outline my notes on what I did for
each task below.

### Task 1

According to this document: https://help.returnpath.com/hc/en-us/articles/220560587-What-are-the-rules-for-email-address-syntax
among other references online it seems that there are 4 verifiable chunks of an email: the recipient name, '@' symbol, domain name and top level domain. I split the verification functions into two methods, each of which have several sub methods that check various aspects of the email address. The check_status method comes back as 'valid' or 'invalid' and stored as such. I also implemented some rspec tests in the email_address_spec file to test these methods.

### Task 2

Most of the work done for this task is in the create method of email_verifications_controller.rb. I modified the params filter
to accept an array of address, so now the proper format to POST to /email_verifications is now:

```
{
 	"email_verification": {
 		"addresses": [
 			{"address": "matthewc@onebrick.org"},
            {"address": "hello@there.com"},
            {"address": "indiana@jones.org"},
 		]
 	}
 	
 }
```
The endpoint is set to handle between 1 and 10 addresses, any more or less and it'll return an error. 

This postman collection link https://www.getpostman.com/collections/de2c78051fbb0bf85bcc contains the POST
endpoint for email verification and auth (see next section) pre-filled. It can be imported in postman by going to
import -> import from link. 
This collection has 2 endpoints, one demonstrating 10 verifications, the first 5 are returned as valid and the second 5 
invalid. The second "Too many emails" POST has one too many emails and thus returns a 422 error.

### Task 3

The requirements for this task seemed like they were a little bit open to interpretation. The two requirements of 

- Only active users can access the api
- Only existing users can access the api 

were pretty straightforward enough, but I got to thinking...how would we know if an existing user is trying to access the api?
I was thinking the basic way of just supplying the username to the post and having a basic check to see if the user exists and is
active might technically satisfy the requirements, but how do we know that the person sending the request is the real user?
So I decided to add some basic auth to the app. First thing to do was to add a password field, which was accomplished by modifying
the create_users file in db/migrate. Then I added the 'bcrypt' gem to the project and added `has_secure_password` to the User model.
This makes sure, on user creation, that the user has a `password` and `password_confirmation`, and then securely hashes the password
so we aren't storing plaintext passwords. Then I implemented an `authenticate` method in the ApplicationController, 
which utilizes `authenticate_or_request_with_http_basic`, which looks for an auth header and converts it to a username/password.
I find the username in the db and check the password by calling  bcrypt's `authenticate` method on the user. If that method passes and 
the user's status is 'active' then the user is authenticated. Finally, I put `before_action :authenticate` on the EmailVerificationsController's
callback method to authenticate the user before any of the api code is run. 

### Task 4

To access the email verification page while running rails server, go to localhost:3000. The root page is the verification page.
However, since I already had very basic authentication set up for the front end, I thought I might as well set up basic session
authentication for the front end. So I implemented a very basic sign up and login form (they are very ugly I apologize) and you will be redirected to the sign in form if you do not have a session. When you sign up or login you get sent to the MainController root page, in which you can submit an email address. The address will be saved and a beautiful (just kidding it's just as ugly) message will pop up from the top of the page declaring if the address is valid or invalid. You will only get to the MainController page if you have a session, and you will also only be able submit an email if you have an active session. This is done by setting the session[:uuid] on login and checking the session[:uuid] on POSTing to the session /create endpoint. 

### Bonus Task: Bulk CSV Upload

For this task I made use of the CSV module and erb's built in mechanisms to import a file that rails provides. 
I check to make sure the total rows are less than or equal to 100, then for each entry I save it to the EmailVerification table, which will check each email's validity. Each email's
verification status is displayed in a beautiful key/value pair on the page.

