import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    @Published var errorMessage: String?
    @Published var savedCity: WeatherModel?
    @Published var state: WeatherViewState = .idle

    private let weatherService = WeatherService()
    private let persistenceKey = "selectedCity"

    func fetchWeather(for city: String) {
        self.updateViewState(.loading)
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.savedCity = weather
                    self?.persistCity(self?.savedCity)
                    self?.updateViewState(.searched)
                case .failure(let error):
                    self?.updateViewState(.error(error.localizedDescription))
                }
            }
        }
    }

    func loadLastCityWeather() {
        if let data = UserDefaults.standard.data(forKey: persistenceKey),
           let decodedData = try? JSONDecoder().decode(WeatherModel.self, from: data) {
            self.savedCity = decodedData
            self.updateViewState(.saved)
        }
    }

    func updateViewState(_ state: WeatherViewState) {
        self.state = state
    }

    private func persistCity(_ cities: WeatherModel?) {
        if let data = try? JSONEncoder().encode(cities), let _ = cities {
            UserDefaults.standard.set(data, forKey: persistenceKey)
        }
    }
}
