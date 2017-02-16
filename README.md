The application is written purely in Swift. The main SDK's used are Apple's MapKit and CoreLocation.
No third party frameworks are used.

The project uses Storyboard and unit tests.
The project can be pulled and run with xcode in the iPhone simulator or on a real device.

Assumptions:
- Sorting by closeness is done by how close the location is to Sydney's CBD.
- To store a persistent file, a simple JSON file was used as this was intented to mimic a social platform of which I
  assumed would communicate with an imaginary backend using JSON. This was my reasoning over using CoreData.

For model objects such as 'SavedLocation' imutable objects were created to encourage thread saftey.
For the 'SavedLocationManager' the model is intented to represent a view of the persistent JSON file and changes are commited
  with the 'saveChanges' method. This class uses a singleton pattern to provide a global instance to make changes to underlying
  data.
For UI elements majority was done in storyboard using Autolayout.
