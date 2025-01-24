import SwiftUI

struct WeatherInfoView: View {
    @Environment(\.colorScheme) var theme
    @State var weather: WeatherModel
    private var weatherInfo: [WeatherInfoModel]

    init(weather: WeatherModel) {
        self.weather = weather
        self.weatherInfo = [
            WeatherInfoModel(label: "Humidity", value: "\(weather.current.humidity)%"),
            WeatherInfoModel(label: "UV", value: String(format: "%.0f", weather.current.uvIndex)),
            WeatherInfoModel(label: "Feels Like", value: String(format: "%.0fº", weather.current.feelsLike))
        ]
    }

    var body: some View {
        VStack {
            iconView

            Text(weather.location.name)
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))

            Text("\(weather.current.temperature, specifier: "%.0f")°")
                .font(.system(size: 70, weight: .bold))

            infoView
        }
    }
}

extension WeatherInfoView {
    private var iconView: some View {
        AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .iconStyle(size: Constants.iconSize)
            case .failure:
                Image(systemName: "exclamationmark.icloud.fill")
                    .iconStyle(size: Constants.iconSize)
            @unknown default:
                Image(systemName: "exclamationmark.icloud.fill")
                    .iconStyle(size: Constants.iconSize)
            }
        }
    }
}

extension WeatherInfoView {
    private var infoView: some View {
        HStack(spacing: 56) {
            ForEach(weatherInfo) { info in
                VStack(spacing: 2) {
                    Text(info.label)
                        .font(.system(size: 12, weight: .medium))
                        .themeStyle(darkColor: Constants.textPrimaryColor.0, lightColor: Constants.textPrimaryColor.1)
                    Text(info.value)
                        .font(.system(size: 15, weight: .medium))
                        .themeStyle(darkColor: Constants.textSecondaryColor.0, lightColor: Constants.textSecondaryColor.1)
                }
            }
        }
        .padding(16)
        .background(theme == .dark ? Color(hex: Constants.backgroundColor.0) : Color(hex: Constants.backgroundColor.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    WeatherInfoView(weather: WeatherModel(
        location: WeatherLocation(name: "London"),
        current: CurrentWeather(
            temperature: 25.5,
            feelsLike: 30.9,
            humidity: 50,
            uvIndex: 4.3,
            condition: WeatherCondition(icon: "https://cdn.weatherapi.com/weather/64x64/day/143.png")
        )
    ))
}
