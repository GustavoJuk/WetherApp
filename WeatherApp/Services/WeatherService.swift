import Foundation
import Combine

class WeatherService {
    private let apiKey = "YOUR_API_KEY"
    private let baseUrl = "https://api.weatherapi.com/v1"
    private var cancellables = Set<AnyCancellable>()

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let endpoint = "\(baseUrl)/current.json?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .sink { sinkCompletion in
                if case .failure(let error) = sinkCompletion {
                    completion(.failure(error))
                }
            } receiveValue: { response in
                completion(.success(response))
            }
            .store(in: &cancellables)
    }
}
