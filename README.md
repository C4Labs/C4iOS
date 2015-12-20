![C4](http://www.c4ios.com/images/c4logo.png)

[![Build Status](https://travis-ci.org/C4Framework/C4iOS.svg?branch=master)](https://travis-ci.org/C4Framework/C4iOS)
# Code, Creatively.

C4 is an open-source creative coding framework that harnesses the power of native iOS programming with a simplified API that gets you working with media right away. Build artworks, design interfaces and explore new possibilities working with media and interaction.

## Version 2.0

Built on top of Swift, C4 puts the power of UIKit and Core Animation at your disposal, allowing you to create inventive digital interactions with far less time and effort. Plus, you get all the interactivity, fun and expressiveness of Swift. Your apps will run lightning-fast.

The API of C4 is simple and streamlined allowing beginners to get into programming very easily. For seasoned developers, C4 can be dropped into any existing project with as little effort as linking any other native framework . With C4, you’ll save a ton of time working with interactions, animation and media.

## Efficient

Spend less time navigating between different frameworks and focus on bringing your ideas to life. C4 combines the power of UIKit and Core Animation into a single set of objects whose APIs are easy to understand and straightforward. And because C4's foundation is built on native frameworks, you’ll be inheriting Swift’s faster code, compile times and optimization for modern hardware.

## Expressive

C4 brings your ideas to life by allowing you to focus on experimenting, designing, visualizing and building rather than on learning low-level technologies. Objects are consistent and intuitive — they all essentially work the same way .  C4's language has been designed to be as simple and expressive as possible.

For example, C4 compresses the access of properties:

```swift
let m = movie.width
```

Instead of this:

```swift
let m = movie.frame.size.width
```

Animating both view and property changes in C4 is much cleaner, and looks like this:

```swift
C4ViewAnimation(duration: 0.5) {
    shape.center = self.canvas.center
    shape.lineWidth = 5
}.animate()
```

Whereas using UIKit + Core Animation you'd have to do something like this:

```swift
UIView.animateWithDuration(0.5) {
    shape.center = self.canvas.center
}

CATransaction.begin()
CATransaction.setValue(NSNumber(float: 0.5), forKey: kCATransactionAnimationDuration)
shape.lineWidth = 5
CATransaction.commit()
```

C4 takes advantage of all of Swift’s modernity: closures, tuples, generics, interaction, structs, error handling. And, YES, you can even do this:

```swift
let bananaName = "Jimmy".banana
```

Check the [Swift Overview](https://developer.apple.com/swift/) for more.

## Easy To Learn

Through both its simplified API and consistent objects, C4 is incredibly easy to learn compared to the frameworks it’s built upon: UIKit, Core Animation, etc. C4’s language has been designed to make it easy for both novice and experienced programmers to pick up and use right away.

## Well Supported

The C4 team has always been highly committed to publishing excellent documentation, examples and tutorials for learning how to program with C4.

The current release of C4 also includes a full end-to-end tutorial that will walk you through the design, creation and publication of a full-blown app: COSMOS

[Get COSMOS from the App Store](https://itunes.apple.com/us/app/c4smos/id985883701?ls=1&mt=8)

[Build COSMOS from start to finish](http://www.c4ios.com/cosmos) 

We’re currently converting over 200 code examples and 30 tutorials to C4's new modern syntax. These examples and tutorials (coming soon) guide new users through core concepts and provide seasoned developers with the reference they need to keep up the pace.

## Powerful

Originally based on Objective-C, C4 now takes entire advantage of the Swift programming language — which itself was built to be fast and powerful. Where Swift has been tuned to make intuitive, natural coding perform best, the guts of each component in C4 — every class, every method and every structure –  make that performance sing.

Through C4 you are able to work with media, animations and interactions in a way that dissolves the differences between the many frameworks you need to create beautiful user experiences. It seamlessly combines many important components of UIKit, Core Animation, Core Graphics, AVFoundation and QuartzCore.

## Multipurpose

C4 is built for anyone who wants to build beautiful user experiences for iOS and has been designed to reach an incredibly broad set of possible uses. This flexibility is one of the most important aspects of C4, demonstrating its strength across a variety of different use cases and disciplines.

C4 has been used for:

- Prototyping
- Mobile Applications
- Data Visualization
- Interactive Artworks
- Computational Design Education
- Communication Design
- Print Design

## Open Source

Sporting the [MIT License](https://en.wikipedia.org/wiki/MIT_License), C4 is an open-source project whose features and functions can be used freely in educational, artistic and even professional settings. The project is open to anyone who wants to contribute, and the project’s code, documentation, and process are completely available for you to read through, learn from and take advantage of. Ongoing commitment by our core team and other developers guarantees that C4 will be constantly updated and focused on user’s interests.

[Join our Slack community!](https://join-c4.herokuapp.com/)

## Simplicity

Simplicity is a major accomplishment for C4. Across the board, C4 is simple to learn, to use, to read and to adopt. C4 reduces the amount of code you need to the most powerful essentials.

Take movies, for example. Instead of needing to AVQueuePlayer, AVPlayerItem, navigating asset tracks and learning how to load files through NSBundle, you only have to create a movie from its file name and add it to the canvas:

```swift
func setup() {
    let movie = C4Movie("myClip.mov")
    canvas.add(movie)
    movie.play()
}
```

Using UIKit + AVFoundation, you'd have to construct the movie object from scratch like this:

```swift
func viewDidLoad() {
    guard let url = NSBundle.mainBundle().URLForResource("myClip.mov", withExtension: nil) else {
        fatalError("File not found")
    }

    let asset = AVAsset(URL: url)
    let player = AVQueuePlayer(playerItem: AVPlayerItem(asset: asset))
    player.actionAtItemEnd = .Pause

    let movieLayer = AVPlayerLayer(player: player)
    movieLayer.videoGravity = AVLayerVideoGravityResize
    self.view.layer.addSublayer(movieLayer)

    player.play()
}
```

… And a whole lot more.
