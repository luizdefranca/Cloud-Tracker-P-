##Cloud Tracker
Learning Outcome
GET and POST to REST API using URLSession
Use two API's in a single project
Encapsulate network code in a dedicated class
Goal
To take the Food Tracking app you built on the weekend and modify it to be a Food Rating app that posts and gets data from a REST api.

Create a signup/login view in our app. This will allow each user of our app to create their own particular meals and ratings.

Overview
We are going to take the Food Tracking app we built on the weekend and modify it to be a Food Rating app that saves and loads data from a REST api.

Since each user of our app will want to log meals, and we want them to be logged separately, we'll need to have a signup/login view in our app. A user can then add a meal, and rate it.

Syncing data between your local storage and the server is difficult. To start with, we'll stop persisting meals to the local disk, and only load them from the server. As a stretch goal, we can use local persistence to make the app work to some extent while offline.

CloudTracker API
The API we're going to use is located at: https://github.com/lighthouse-labs/iOS-CloudTracker-Server

Read the API guide API Guide.

Practice all of the commands in the API documentation before writing any code. Use either Curl (built in to the command line), or use another tool like: Rested (free Mac App), Paw (free trial available), PostMan (free Chrome extension), etc. PostMan and Paw both allow you to copy and paste Curl commands.

Your model objects are going to have to change a bit to match the data the API provides. We need to add calories (Int) and description (String). Make the changes to your Meal model object as well. The JSON will return a id for the meal, which you may also want to add to the model. Look at the JSON you got back when you did the test requests using your REST tool. You also get back a user_id property. It's up to you if you want to add that to your model as well. We probably won't need it. Make sure you test the user input code.

If you get stuck with crafting a valid request, an example signup request can be found here.

We have listed the steps in a particular order below, but feel free to alter this order. For instance, you may want to start with displaying all meals first after you create a user using your REST tool and some dummy meal objects and then do the meal creation flow. It is important to think through these steps for yourself and adopt an order that makes the most sense.

Steps
Read all Instructions Start by reading through all the instructions.

Create a Branch

Using the weekend's FoodTracker project assignment make a new branch.
Note: if you did not complete the assignment you have two choices. 1. Go back and complete the assignment or 2. download the completed assignment from Apple. If you go with the second option you should come back to this assignment to finish it.
Add a Signup Screen.

When your app launches, check whether you have saved the user's credentials in UserDefaults and show the signup screen if there is no saved user. A good place to put this check is viewDidAppear on your root view controller.
Have a text field for username and password.
Do some basic validation on the username and password. The server will accept anything, but we might want to add a minimum password length, for example.
When the user hits the signup button with a valid username/password, call the /signup endpoint on the server.
Persist the User's Credentials

The ideal place to securely persist user credentials is in the keychain. But for now we can use UserDefaults instead. Persisting to the keychain is a stretch goal, listed below.
So, persist the username, password and token to the UserDefaults.
If signup is unsuccessful, let the user know with an alert so they can try again.
Add a Login Screen.

This can be the signup screen in a different mode, or a separate view controller.
There is a /login endpoint which can be used to exchange a username and password for an access token.
Save the new token if successful. If it fails alert the user to try again.
Refactoring Requests.

At this point you should have two different API calls. The login and signup requests. You'll notice they look quite similar, but have subtle variations in what they send and how to respond when they're done.
Since we're going to add even more requests, it makes sense to start building some sort of CloudTrackerAPI manager/handler class, to consolidate some of this code.
Whenever possible prefer a single method that can be used for multiple requests. You may not want to consolidate everything into just one method, as it'll have too many if-else's. But for example having one method for all the POSTs and one for all the GETs is a good level of abstraction.
You can build convenience methods for each endpoint or request. E.g. your post method post(data: [String: AnyObject], toEndpoint: String, completion: (NSData?, NSError?)->(Void)) that does the post, and one method for saving a meal saveMeal(meal: Meal, completion: (NSError?)->(Void)) that calls the post method. But start simple. Get the requests working, and then refactor.
Add New Text Fields to the Meal Creation Screen

The meal creation endpoint expects more than we're currently collecting, so add two new inputs:
calories: Int
description: String
Add these properties to the Meal object as well as the two id properties the server's meal object has (userId and id).
Save New meals to the Server.

Send a POST request to the /users/me/meals endpoint to save this meal to the server.
Don't allow the user to leave the meal creation screen while the save is happening.
Notice a limitation of the API: the initial creation of a meal on the server doesn't accept a rating or an image.
We will deal with images in the next section using the Imgur API. So for now, just ignore the image.
To add the rating you will have to first create a meal object and then do a second request to add the rating to the returned meal. Remember this is an asyncrhonous request so you will have to update the meal object with the rating in the completion handler of the meal creation request.
Show All the Meals in the Main Table View Controller.

Perform a GET request to fetch all meals and display them in the table view controller.
Convert the JSON response into meal objects.
Reload the table on the Main Queue.
Imgur API

We are going to post images to Imgur anonymously. This is very easy.

Start by quickly perusing the API Docs to familiarize yourself with this API.

Notice we are not using OAuth. We are posting and reading public read-only and anonymous resources.

Imgur says that each client needs to register an app and they will receive a client_id and client_secret. You can also just use my client_id (more on this in a moment).

We only need the client_id for our level of access.

Our requests will include Authorization: Client-ID <YOUR_CLIENT_ID> in the header. (Notice <YOUR_CLIENT_ID> is either your client_id or the one you will get below that I have registered.

Here is a gist which gives you my client_id. You are free to use it or register your own.

You can see the CURL requests in the gist.

In your REST tool (Curl, Paw, etc.) you will upload an image. Get that working before moving to the next step.

Adding An Image To Your Meal. - Now that you can make requests with your REST tool, simply convert this knowledge to making the Swift POST request for saving the image. This will require you to convert the image to a Data object. - Notice, if you inspect the returned JSON after you post the image you will have a link that you need to store in your model object. - You will need to save the image first and wait for the call to return the JSON before saving the Meal object with the URL, since the Meal object needs the image link! This is critical.

Fetch Images In TableView - Once you can save images to Imgur and save their URL's to the CloudTracker you will be able to fetch them again once your table view is displaying. - This is going to be a simple request using the link. - You can use URLSession's download functionality to do this. - Remember to call back to the Main Queue once the image is returned. It will be returned as a Data blob which you will convert to a UIImage.

Editing Functionality - CloudTracker has a detail view that allows editing the Meal image and rating. Implement this next. - Look over the CloudTracker API documentation to see how to update the Photo URL and ratings. Do a practice post for each of these in your REST tool to make sure you understand them before implementing this in code.

Stretch Goals
Add UIActivityIndicatorView

When the user adds a meal make sure you let them know what's happening with a UIActivityIndicatorView.
Cache Images

Instead of fetching the images each time you display them try adding a simple array of images and check that array before fetching anything. If the image already exists locally use it instead of fetching a new one.
Input validation

Only enable the login or signup button if the username and password pass validation, rather than doing the validation after the user presses login.
Profile screen

Make a "profile" screen, accessible from a button on your main Table View Controller.
Immediately populate the screen with the username from NSUserDefaults.
At the same time, do a network request to refresh this data from the server, in case the user has changed their username (or other profile data, if the API adds support for this).
Logout button

Add it to the profile screen.
It should forget the user's credentials, and return the user to the login/signup screen.
Implement Imgur's OAuth Workflow

Instead of posting and reading images anonymously implement Imgur's OAuth workflow instead.
Keychain

Store user credentials in the keychain, rather than NSUserDefaults.
Consider your options and timeframe, and either do it by hand or use a pod to make this easier.
My Rated Foods

Add a tableView to your Profile that lists all the foods you have rated 4 or 5 stars:
Since the server does not provide an endpoint for this, you'll have to fetch all meals, and filter the list client side (e.g. rating > 3).
Offline cache
As mentioned at the start, syncing is difficult. Below you'll find a few simple strategies to deal with or avoid syncing. Spend some time deciding what your strategy will be. Talk it over with a mentor if you're unsure.

Saving meals:

We have the choice of persisting them locally, and then syncing them to the server when available. This adds much complexity in terms of syncing with the server, but allows the app to be fully used offline.
Or, we could save the meal to the server, and only save it to our local store if the save to the server worked. This is a much simpler model, but means are app won't be able to create new meals while offline.
Editing meals:

Again we have the choice of only allowing editing while we have access to the server, or manually making sure data makes it to the server at a later date.
For the latter, you'll need a way to mark meals as "dirty". I.e. something has changed on them, so next time we talk to the server we need to change the image or the rating, etc.
Showing a list of meals on our main table view:

A good strategy for this is to immediately show everything stored in the local store. Perform a network request. If the request succeeds, delete all the meals in our local store, and create new objects with the data from the server.
If you're doing full offline support, this would be the moment when you look for meals marked "dirty" (modified but not updated on the server) and update the server.
