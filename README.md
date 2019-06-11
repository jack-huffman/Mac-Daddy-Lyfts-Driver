# Mac Daddy Lyfts Driver
An iOS application developed from February 2018 - May 2018 during my team based iOS development course.

## Overview
This iOS application was developed for a company based out of Columbia, MO. The company's service was similar to Uber,
in that they would pick up customers in their golf carts and take them to destinations within the city. Our team developed
2 applications to facilitate bringing together customers and the golf cart drivers. This application would've been used by
the golf cart drivers to locate people requesting a ride and get mapped to their location. While the Laravel server used to
send data between the apps is no longer functioning, this application served as one of our MVPs that was delivered to the
local company.

### Explanation of User Experience
Upon opening the app, the user would be prompted to enter in the login information for accessing the golf carts. After entering 
the correct information, the user would segue to a new ViewController that would contain three buttons - one for each golf cart.
The app would check the status of these golf carts on our server to see if anyone was currently driving any of the carts, and would
either activate or deactivate the buttons for each cart depending on its status. If not all three were currently being driven, then 
the user would pick a cart to drive and then would segue to the MapViewController.

### The MapView and Accepting a Ride
This view controller handled most of the work in the application. When the view loads, the app would check our personal server for any
ride requests from customers and would use this data to create pins on the map view. The driver would be able to select a pin
to view more information about the ride, or potentially accept it. Every 15 seconds, the driver's location would be pushed onto the 
server to be accessed by the rider (similar to how user's can see the location of nearby drivers in the Uber app). The driver 
could also change their availability with a toggle in the top-left corner of the display and state if they are active or inactive.
This data would also be pushed with their location, so users could see if a particular driver is busy or not. Upon tapping the "Info"
button on the pin, the user would segue to a new ViewController displaying even more information about the request. Here the user
can accept the ride, or return to the map view. After accepting a ride, Maps will open and begin routing the user to the location of
the ride request. Buttons will also appear allowing the user to call the user, or finish the ride.

### iOS Concepts Implemented
The main functionalities utilized in this application stem from the MapKit framework. It allowed the map to be created and for
annotations to be added to the map. Upon a successful login attempt at the home screen, the information would be stored in Core Data,
making future logins much faster. Asynchronous API calls were also used for retrieving and updating information about riders
and drivers on our server.
