# Custom Action Sheet for UIKit and SwiftUI

This custom action sheet allows displaying an action sheet the same way that is shown on iPhone for iPads

## Usage for UIKit

First, we need to create a new instance of the class `ActionSheetView.Builder`

```swift
ActionSheetView.Builder()
```

After that, there comes the magic!

```swift
ActionSheetView.Builder()
    .withTitle("This is my action sheet title")
    .withMessage("This is the message")
    .withButton(title: "This is a normal action") { print("and this is the action of the button") }
    .withButton(title: "This is a destructive action", style: .destructive)
    .withButton(title: "this is a cancel action", style: .cancel)
    .withBackgroundColor(.black.opacity(0.4))
    .withPresentationStyle(.overCurrentContext)
    .present(in: self)
```

If we want to give to the action sheet a title then we will use the function `.withTitle(title)`.

In the case that we want to add a message then we willl use the function `.withMessage(message)`.

Then, to add buttons, we will use the function `.withButton(title, style, action)`. We can give to the button a `title`, `style`, and an `action`.

We will use the function `.withBackgroundColor(color)` to change the action sheet background color.

If we want to change the way the action sheet is presented, then we will use the function `.withPresentationStyle(style)`.

And lastly, to present the action sheet, we will use the function `present(in viewController)`.

## Usage for SwiftUI

The usage here for SwiftUI is almost the same as on UIKit. 

First, we are going to need a `@State` bool variable. You can call it however you want. In this example, I'm going to call it `isShowingActionSheet`.

```swift
@State var isShowingActionSheet = false
```

Then, we will add whatever we want to use to change that variable on our body computed variable. I'm going to use a button

```swift
@State var isShowingActionSheet = false

var body: some View {
    Button("Click here to show the action sheet") {
        isShowingActionSheet.toggle()
    }
}
```

Then, we will use a `fullScreenCover` to present the action sheet. Inside it, we are going to create an instance of the `ActionSheetView` view

```swift
@State var isShowingActionSheet = false

var body: some View {
    Button("Click here to show the action sheet") {
        isShowingActionSheet.toggle()
    }
    .fullScreenCover(isPresented: $isShowingActionSheet) {
        ActionSheetView()
    }
}
```

And finally, we can start updating our action sheet just like UIKit

```swift
@State var isShowingActionSheet = false

var body: some View {
    Button("Click here to show the action sheet") {
        isShowingActionSheet.toggle()
    }
    .fullScreenCover(isPresented: $isShowingActionSheet) {
        ActionSheetView()
            .withTitle("This is a custom action sheet!")
            .withButton(title: "This is a normal action")
    }
}
```

The only difference between the UIKit and the SwiftUI version is when the time to dismiss the action sheet comes.

```swift
@State var isShowingActionSheet = false

var body: some View {
    Button("Click here to show the action sheet") {
        isShowingActionSheet.toggle()
    }
    .fullScreenCover(isPresented: $isShowingActionSheet) {
        ActionSheetView()
            .withTitle("This is a custom action sheet!")
            .withButton(title: "This is a normal action")
            .dismissAction {
                isShowingActionSheet.toggle()
            }
    }
}
```

And that's all you need to know to start using this! You can change whatever you want if you think there needs to be something or know how to implement it better.
