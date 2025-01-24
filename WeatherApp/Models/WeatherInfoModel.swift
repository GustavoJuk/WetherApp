import Foundation

struct WeatherInfoModel: Identifiable {
    var id = UUID()
    var label: String
    var value: String
}
