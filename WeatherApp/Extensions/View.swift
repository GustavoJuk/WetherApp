import SwiftUI

extension View {
    func themeStyle(darkColor: String, lightColor: String) -> some View {
        self.foregroundStyle(Color(hex: darkColor), Color(hex:lightColor))
    }

    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardModifier())
    }
}

extension Image {
    func iconStyle(size: CGFloat) -> some View {
        self.resizable()
            .frame(width: size, height: size)
            .scaledToFit()
    }
}

struct DismissKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        dismissKeyboard()
                    }
            )
            .onTapGesture {
                dismissKeyboard()
            }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
