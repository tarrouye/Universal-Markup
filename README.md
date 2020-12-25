# Universal Markup

### Universal Markup is a simple application with one goal: bring markup tools to any app on macOS

It does this by displaying a 'capture frame' that floats above all other apps. Users can resize and move the capture frame to anywhere on their screen, mark it up, and capture the resulting image.

Here is an example of Universal Markup being used to highlight some text in Microsoft Edge.
![Example image](example_image_1.png?raw=true "Universal Markup in use")
Universal Markup consists of two windows: the Capture Frame (the black rectangle in the image above) and the Tools Window 


### Technologies Used

Universal Markup is built using Swift and SwiftUI. 

The Tools Window is (at the time of writing :P) 100% SwiftUI. 

The Capture Frame uses AppKit and CoreGraphics to display the floating frame and perform markup operations. 

The intention was to utilize PencilKit for the mark-up operations but proper macOS support for PencilKit was cut in earlier betas. If (when?) PencilKit annotation officially comes to macOS I hope to migrate to that.
