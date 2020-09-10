# Ghent Live Parking

## A demo app for In The Pocket.

The emulator is made with `UIKit` to support iOS13. App is tested on an `iPhone 11 Emulator` running `iOS 13.0`. The app will let you pick a parking spot from an `up-to-date API` provided by Ghent. The user can park his car and the map will update with the current location of your car.

All functional requirements have been met.

![Home Screen](https://i.imgur.com/oG0u7PK.png)
![Detail Screen](https://i.imgur.com/hhqsYjY.png)

---

### Setup

If using an emulator: note that location needs to be set in the emulator

> Emulator > Features > Location > Custom Location

I used a custom location of my old kot.

```
Latitude: 51,039801
Longitude: 3,72443
```

---

Mind that backgroundtasks won't work on an emulator.

### Design

[Check on Figma](https://www.figma.com/file/bMcWeQPsCLTHwDA3MsmAzj/In-The-Pocket-Ghent-Parking?node-id=0%3A1)

### Technologies Used

- UIKit (without storyboards)
- Swift 5
- CoreData
- URLSession
- Location
