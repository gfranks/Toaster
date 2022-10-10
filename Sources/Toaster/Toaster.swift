//
//  Toaster.swift
//  Trackr
//
//  Created by Garrett Franks on 10/5/22.
//

import SwiftUI

// MARK: - TOASTER TYPES

/// ToasterType used for styling our Toaster
/// This has premaid text and background colors as well as icons
public enum ToasterType {
	case warning, error, success, info
	
	var textColor: Color {
		switch self {
		case .warning:
			return .black
		case .error:
			return .white
		case .success:
			return .white
		case .info:
			return .white
		}
	}
	
	var backgroundColor: Color {
		switch self {
		case .warning:
			return .yellow
		case .error:
			return .red
		case .success:
			return .blue
		case .info:
			return .blue
		}
	}
	
	var icon: String {
		switch self {
		case .warning:
			return "exclamationmark.triangle.fill"
		case .error:
			return "exclamationmark.circle.fill"
		case .success:
			return "checkmark.circle.fill"
		case .info:
			return "info.circle.fill"
		}
	}
}

// MARK: - TOASTER DATA

/// Toaster data used to create our Toast message
public class ToasterData: Equatable {
	
	let title: String
	let message: String?
	var titleFont: Font
	var messageFont: Font
	var icon: String
	var iconColor: Color
	var titleColor: Color
	var messageColor: Color
	var backgroundColor: Color
	var position: ToasterPosition
	var autoDismiss: Bool
	var duration: CGFloat
	
	/// Creates a ToasterData
	/// - Parameters:
	///  - title: The title of this Toaster
	///  - message: The message of this Toaster
	///  - titleFont: The title font to use, defaults to `.system(.title)`
	///  - messageFont: The title font to use, defaults to `.system(.body)`
	///  - icon: The icon to use with this Toaster. If none provided, will use premaid icon based on the ToasterType
	///  - iconColor: The icon color to use for all icons within the Toaster. If none provided, will use premaid Colors based on the ToasterType
	///  - titleColor: The text color to use for the title within the Toaster. If none provided, will use premaid Colors based on the ToasterType
	///  - messageColor: The text color to use for the message within the Toaster. If none provided, will use premaid Colors based on the ToasterType
	///  - backgroundColor: The background color of this Toaster. If none provided, will use premaid Colors based on the ToasterType
	///  - position: The position the Toaster should be displayed from [top, bottom]
	///  - autoDismiss: Whether the Toaster should auto dismiss after the duration has lasped
	///  - duration: The duration before the Toaster will aut dismiss
	public init(
		title: String = "",
		message: String? = nil,
		titleFont: Font = .system(.title),
		messageFont: Font = .system(.body),
		titleColor: Color,
		messageColor: Color,
		icon: String,
		iconColor: Color,
		backgroundColor: Color,
		position: ToasterPosition = .top,
		autoDismiss: Bool = true,
		duration: CGFloat = 5
	) {
		self.title = title
		self.message = message
		self.titleFont = titleFont
		self.messageFont = messageFont
		self.titleColor = titleColor
		self.messageColor = messageColor
		self.icon = icon
		self.iconColor = iconColor
		self.backgroundColor = backgroundColor
		self.position = position
		self.autoDismiss = autoDismiss
		self.duration = duration
	}
	
	/// Creates a ToasterData
	/// - Parameters:
	///  - title: The title of this Toaster
	///  - message: The message of this Toaster
	///  - titleFont: The title font to use, defaults to `.system(.title)`
	///  - messageFont: The title font to use, defaults to `.system(.body)`
	///  - type: The type of this Toaster. See `ToasterType`
	///  - position: The position the Toaster should be displayed from [top, bottom]
	///  - autoDismiss: Whether the Toaster should auto dismiss after the duration has lasped
	///  - duration: The duration before the Toaster will aut dismiss
	public convenience init(
		title: String = "",
		message: String? = nil,
		titleFont: Font = .system(.title),
		messageFont: Font = .system(.body),
		type: ToasterType = .success,
		position: ToasterPosition = .top,
		autoDismiss: Bool = true,
		duration: CGFloat = 5
	) {
		self.init(
			title: title,
			message: message,
			titleFont: titleFont,
			messageFont: messageFont,
			titleColor: type.textColor,
			messageColor: type.textColor,
			icon: type.icon,
			iconColor: type.textColor,
			backgroundColor: type.backgroundColor,
			position: position,
			autoDismiss: autoDismiss,
			duration: duration
			
		)
	}
	
	@ViewBuilder
	public func makeToast<ViewContext>(viewContext: ViewContext) -> some View where ViewContext: View {
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: self.icon)
				.imageScale(.medium)
				.foregroundColor(self.iconColor)
			
			VStack(alignment: .leading) {
				Text(self.title)
					.font(self.titleFont)
					.foregroundColor(self.titleColor)
				
				if let message = self.message {
					Text(message)
						.font(self.messageFont)
						.foregroundColor(self.messageColor)
				}
			}
			
			Spacer()
		}
		.padding()
		.background(self.backgroundColor)
		.cornerRadius(10)
		.shadow(radius: 2)
		.padding([.leading, .trailing, .bottom], 20)
		.padding(self.position == .bottom ? .bottom : .top)
	}
	
	public static func == (lhs: ToasterData, rhs: ToasterData) -> Bool {
		lhs.title == rhs.title && lhs.message == rhs.message && lhs.position == rhs.position
	}
}

// MARK: - TOASTER POSITION

/// The position of which the Toaster will be displayed from
public enum ToasterPosition {
	case top, bottom
	
	var edge: Edge {
		switch self {
		case .top:
			return .top
		case .bottom:
			return .bottom
		}
	}
}

// MARK: - TOASTER

/// A fully customizable Toaster simulating an Android "Toast"
public struct Toaster: ViewModifier {
	
	@Binding private var isShowing: Bool
	private var position: ToasterPosition
	private var autoDismiss: Bool
	private var duration: CGFloat
	private var enableTapToDismiss: Bool
	private var enableBackgroundTapToDismiss: Bool
	private var enableDragDetection: Bool
	private var overlayBackgroundColor: Color
	private var slideOverContent: (_ content: Content) -> AnyView
	
	/// Creates a robust Toaster with a customizable View
	/// - Parameters:
	///  - isShowing: Binding<Bool> determining if this Toaster should be showing
	///  - position: The position the Toaster should be displayed from [top, bottom]
	///  - autoDismiss: Whether the Toaster should auto dismiss after the duration has lasped
	///  - duration: The duration before the Toaster will aut dismiss
	///  - enableTapToDismiss: When enabled, the Toaster can be dismissed by simply tapping the View
	///  - enableBackgroundTapToDismiss: When enabled, the Toaster can be dismissed by simply tapping the behind the View
	///  - enableDragDetection: When enabled, the Toaster can be dismissed by dragging up or down
	///  - overlayBackgroundColor: The background overlayed behind the Toaster. This will appear as full screen. Useful for custom Toasters
	///  - slideOverContent: The Toaster content to be overlayed
	public init(
		isShowing: Binding<Bool>,
		position: ToasterPosition = .top,
		autoDismiss: Bool = true,
		duration: CGFloat = 5,
		enableTapToDismiss: Bool = true,
		enableBackgroundTapToDismiss: Bool = false,
		enableDragDetection: Bool = true,
		overlayBackgroundColor: Color = .clear,
		slideOverContent: @escaping (_ content: Content) -> AnyView
	) {
		self._isShowing = isShowing
		self.position = position
		self.autoDismiss = autoDismiss
		self.duration = duration
		self.enableTapToDismiss = enableTapToDismiss
		self.enableBackgroundTapToDismiss = enableBackgroundTapToDismiss
		self.enableDragDetection = enableDragDetection
		self.overlayBackgroundColor = overlayBackgroundColor
		self.slideOverContent = slideOverContent
	}
	
	private func backgroundWidth(geometry: GeometryProxy) -> CGFloat {
#if canImport(UIKit)
		return UIScreen.main.bounds.width
#else
		return geometry.size.width
#endif
	}
	
	private func backgroundHeight(geometry: GeometryProxy) -> CGFloat {
#if canImport(UIKit)
		return UIScreen.main.bounds.height
#else
		return geometry.size.height
#endif
	}
	
	@ViewBuilder
	private func backgroundContent(geometry: GeometryProxy) -> some View {
		let content = self.overlayBackgroundColor
			.frame(width: self.backgroundWidth(geometry: geometry), height: self.backgroundHeight(geometry: geometry))
			.opacity(self.isShowing ? 1.0 : 0)
		
		if self.enableBackgroundTapToDismiss {
			content.edgesIgnoringSafeArea(.all).onTapGesture {
				withAnimation {
					self.isShowing.toggle()
				}
			}.animation(.easeInOut, value: self.isShowing)
		}
		else {
			content.edgesIgnoringSafeArea(.all)
				.animation(.easeInOut, value: self.isShowing)
		}
	}
	
	@ViewBuilder
	private func overlayContent(content: Content) -> some View {
		VStack {
			if self.isShowing {
				VStack {
					if self.position == .bottom {
						Spacer()
					}
					
					self.slideOverContent(content)
					
					if self.position == .top {
						Spacer()
					}
				}
				.transition(AnyTransition.move(edge: self.position.edge).combined(with: .opacity))
				.onTapGesture {
					if self.enableTapToDismiss {
						withAnimation {
							self.isShowing.toggle()
						}
					}
				}
				.gesture(
					DragGesture()
						.onEnded { _ in
							if self.enableDragDetection {
								self.isShowing.toggle()
							}
						}
				)
				.onAppear {
					if self.autoDismiss {
						DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
							withAnimation {
								self.isShowing = false
							}
						}
					}
				}
			}
		}
		.animation(.spring(), value: self.isShowing)
	}
	
	public func body(content: Content) -> some View {
		GeometryReader { geo in
			if #available(iOS 15.0, *) {
				content
					.overlay(self.backgroundContent(geometry: geo))
					.overlay {
						self.overlayContent(content: content)
					}
			}
			else {
				content
					.overlay(self.backgroundContent(geometry: geo), alignment: .center)
					.overlay(self.overlayContent(content: content), alignment: .center)
			}
		}
	}
}

public extension Toaster {

	/// Creates a simple toaster based on the ToasterData
	/// - Parameters:
	///  - isShowing: Binding<Bool> determining if this Toaster should be showing
	///  - data: ToasterData including the information you wish to display
	init(isShowing: Binding<Bool>, data: ToasterData) {
		self.init(isShowing: isShowing, position: data.position, autoDismiss: data.autoDismiss, duration: data.duration) { viewContext in
			AnyView(data.makeToast(viewContext: viewContext))
		}
	}
}

// MARK: - PREVIEWS

/// Robust Toaster example using a custom View
fileprivate struct ToasterCustom: View {
	
	@State private var isShowing: Bool = false
	
	var body: some View {
		VStack {
			Spacer()
			Text("Toaster custom example")
			Spacer()
		}
		.modifier(
			Toaster(
				isShowing: .constant(true),
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

/// Simple Toaster example using ToasterData
struct ToasterInfo_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			Text("Toaster info example")
			Spacer()
		}
		.modifier(Toaster(isShowing: .constant(true), data: ToasterData(title: "Hello", message: "Here's some info.", position: .bottom)))
	}
}

fileprivate struct ToasterCustom_Previews: PreviewProvider {
	static var previews: some View {
		ToasterCustom()
	}
}
