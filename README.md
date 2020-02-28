# Calculator
A recreation of the iOS Caculator app in SwiftUI

Welcome to my child.
 
 This version of the app is way better than the App Inventor version. For starters, it has its own app icon that looks beautiful. It supports iOS 13 dark mode (I'd actually reccommend viewing in dark mode because it looks much prettier, if you don't know how to do that I'll show you).
 
 This is built using Apple's new SwiftUI framework, which is a declarative UI framework which differs from an imperative framework in many ways. Notice I don't create variables for each view, or ever call view.setBackgroundColor(.someBoringColor). I could discuss this for a while but I'm sure I'm going to do that in class.
 
 I had to learn these things called "Bindings" in order to use SwiftUI. You'll notice I have a few different separated views, such as CalcButton, CalcOperationButton, CalcNumberButton, etc. Most of these just create a new instance of CalcButton with their own action. This way all I had to do to make new numbers was create this and give it a number. Bindings are ways to reference the same variable through multiple levels of these views. State variables just let the framework know that these variables are going to be changing, and when they do make sure to update the UI.
 
 For the operations, I created an enum called OperationType that lets me easily set each operation type. This made adding new operations as simple as adding a new value to OperationType, handling it in performOperation, and creating the button for it (CalcOperationButton).
 
 Using inline if statements when setting certain variables like text and color, I was able to make the UI auto update when an operation is the next to be selected or if we're in AC mode instead of C. This is why this version actually has highlighted operation buttons.
 
 NumberFormatter formats the number with commas and the right number of decimal places. I wanted to have it so when the number got big it would go scientific, but couldn't figure that out. However, the calculator does stop you from inputting super large numbers and the text gets smaller as more numbers are entered, but if your result is a really large number then it still truncates.
 
 Obviously there are still things I'd love to add, like the landscape version of the regular calculator app that opens a lot more functions, but I didn't have the time. Please don't try out landscape mode in this app, it's horrible.
 
 Also, I didn't add the swipe to delete feature from the regular calc app (or copy/paste) but I did add a back button which is more intuitive in my mind (I legit forgot about the swipe to delete until someone told me).
 
 Overall I had lots of fun designing this and I'm legit going to use it as my main calculator app on my phone now. I spent way too long outside of class on this as well just for fun. SwiftUI is a really fun framework to play with and I can't wait to learn more about it (like using it with the Combine framework).
