# The WSIE Api - Documentation:

## What is this API for and how does it work=?
The API is designed to work for the WSIE-iOS and (planned in future) WSIE-Web-App. Over this API the application requests the recipe data for each user using the unique user Id.
Also the user can log in over this API to get their userId, for requesting their recipes.

## How you can request data:
### Test connection
#### Request the "It works!" message to test your implementation
GET: https://api.wsie.bembleapps.tech/health

If it works you will get the message "It works!"

### Log in / Create user:
#### Request our userId while sending the hashed password (we are using SHA512):
POST: https://api.wsie.bembleapps.tech/user/login/
```
{
	"email": "[your email]",
	"pwHash": "[your hashed password]"
}
```
If succeds, the server will answer with your generated user id

#### Register for WSIE:
POST: https://api.wsie.bembleapps.tech/user/register/
JSON Body:
```
{
	"name": "[Your name]",
	"email": "[Your email]",
	"pwHash": "[Your hashed password]"
}
```

#### Deleting user
DELETE: https://api.wsie.bembleapps.tech/user/deleteUser/

