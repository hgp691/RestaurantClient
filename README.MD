# Restaurant Client

## Requirements
**Xcode 14.0.1**\
**iOS 12+**\
I use **`SPM`** to manage a library that handles downloading images. I have done it by hand before but it took me longer to cache the images.

## Technical choices
### Network Layer
I chose the native `URLSession` framework for networking. I did the testing of it and handle the errors of the application.
### Persistance Layer
I chose the native `CoreData` Framework to solve the saving of favorites. I tested the functionality.\
In the implementation of the protocol I made a safe thread so that the data is read and written from the same thread.
### DataManager
I made an intermediate layer between (Networking, CoreData) and the RestaurantList feature. I did the dependency injection in the initializer to be able to make mocks.
### Views
Being a single screen application, I opted for a MVVM architecture without Coordinator to make it simpler. 
I made a ViewController where I load a TableView and it is handled by a ViewModel. 
Communications are done through closures.

I made a custom Cell that doesn't use Interface Builder and everything is done by code. This cell also has its own ViewModel to get the data.

## Potential Difficulties and Problems
- Missing ViewController and Cell tests.
- The protocol for persistence (`RestaurantStorageProtocol`) can be divided into two that better comply with the Solid principle of interface segregation.
- Missing error handling in the ViewController.
- The way that the MainImage is obtained is wrong for two restaurants. This must be fixed.
