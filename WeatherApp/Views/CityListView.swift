import SwiftUI

struct CityListView: View {
    @Environment(\.colorScheme) var theme
    private var cityWeather: WeatherModel

    init(cityWeather: WeatherModel) {
        self.cityWeather = cityWeather
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 13) {
                Text(cityWeather.location.name)
                    .font(.system(size: 20, weight: .semibold))
                Text(String(format: "%.0fº", cityWeather.current.temperature))
                    .font(.system(size: 60, weight: .medium))
            }

            Spacer()

            weatherIcon(icon: cityWeather.current.condition.icon)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 31)
        .padding(.vertical, 16)
        .background(theme == .dark ? Color(hex: Constants.backgroundColor.0) : Color(hex: Constants.backgroundColor.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension CityListView {
    private func weatherIcon(icon: String) -> some View {
        AsyncImage(url: URL(string: "https:\(icon)")) { phase in
            switch phase {
            case .empty:
                EmptyView()
            case .success(let image):
                image
                    .iconStyle(size: 83)
            case .failure:
                Image(systemName: "exclamationmark.icloud.fill")
                    .iconStyle(size: 83)
            @unknown default:
                Image(systemName: "exclamationmark.icloud.fill")
                    .iconStyle(size: 83)
            }
        }
    }
}

#Preview {
    Group {
        CityListView(cityWeather:
                        WeatherModel(
                            location: WeatherLocation(name: "Rome"),
                            current: CurrentWeather(
                                temperature: 1,
                                feelsLike: 27.0,
                                humidity: 34,
                                uvIndex: 3,
                                condition: WeatherCondition(icon: "")
                            )
                        )
        )
        CityListView(cityWeather:
                        WeatherModel(
                            location: WeatherLocation(name: ""),
                            current: CurrentWeather(
                                temperature: 1,
                                feelsLike: 27.0,
                                humidity: 34,
                                uvIndex: 3,
                                condition: WeatherCondition(icon: "https://cdn.weatherapi.com/weather/64x64/day/143.png")
                            )
                        )
        )
    }
}
