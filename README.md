# Toaster

Simulates an Android 'Toast' via modifier.

### Supported Platforms
* macOS 12+
* iOS 14+

### Default 'Toaster' Types
These types come with their own text and background colors but are customizable
```
public enum ToasterType { case warning, error, success, info }
```

### Supported Positions
```
public enum ToasterPosition { case top, bottom }
```

## Example
https://user-images.githubusercontent.com/2064984/194924335-0109f377-56f6-4a4c-a5b0-aeafdb7af55d.mov


## Usage
### Info Toaster
```
struct MyView: View {

	@State private var isShowingToaster: Bool = false

	var body: some View {
		VStack {
		
		}
		.modifier(
			Toaster(
				isShowing: self.$isShowingToaster, 
				data: ToasterData(title: "My title", message: "My message", type: .success, position: .bottom)
			)
		)
	}
}
```

### Custom Toaster
```
struct MyView: View {

	@State private var isShowingCustomToaster: Bool = false
	
	var body: some View {
		VStack {
		
		}
		.modifier(
			Toaster(
				isShowing: self.$isShowingCustomToaster,
				autoDismiss: false,
				enableBackgroundTapToDismiss: true,
				enableDragDetection: false,
				overlayBackgroundColor: .black.opacity(0.2),
				slideOverContent: { viewContext in
					AnyView(
						VStack {
							HStack {
								Spacer()
								
								Button(action: {
									withAnimation {
										self.isShowing.toggle()
									}
								}) {
									Image(systemName: "xmark")
										.imageScale(.medium)
										.foregroundColor(.white)
										.padding(10)
										.padding(.trailing, 20)
								}
							}
							
							Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
								.multilineTextAlignment(.center)
								.padding(.horizontal)
						}
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.shadow(radius: 2)
						.padding(.top)
					)
				}
			)
		)
	}
}
```
### SPM
Add 'Toaster' to your project by including the URL to this package - https://github.com/gfranks/Toaster
