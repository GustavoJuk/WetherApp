struct WeatherModel: Codable {
    let location: WeatherLocation
    let current: CurrentWeather
}

struct WeatherLocation: Codable {
    let name: String
}

struct CurrentWeather: Codable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let uvIndex: Double
    let condition: WeatherCondition

    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case feelsLike = "feelslike_c"
        case humidity = "humidity"
        case uvIndex = "uv"
        case condition
    }
}

struct WeatherCondition: Codable {
    let icon: String
}

enum WeatherViewState {
    case searched
    case saved
    case error(String)
    case loading
    case idle
}
