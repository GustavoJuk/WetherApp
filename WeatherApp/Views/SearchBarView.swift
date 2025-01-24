import SwiftUI

struct SearchBarView: View {
    @Environment(\.colorScheme) var theme
    @Binding var city: String
    let onSearch: (String) -> Void
    private var isSearchEnabled: Bool {
        city.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            TextField(Constants.placeholderText, text: $city)
                .submitLabel(.search)
                .onSubmit {
                    if !isSearchEnabled {
                        onSearch(city)
                    }
                }

            HStack {
                Spacer()

                Image(systemName: Constants.magnifyingglass)
                    .themeStyle(darkColor: Constants.textPrimaryColor.0, lightColor: Constants.textPrimaryColor.1)
            }
        }
        .padding()
        .background(theme == .dark ? Color(hex: Constants.backgroundColor.0) : Color(hex: Constants.backgroundColor.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    SearchBarView(city: .constant("London")) { _ in }
}
