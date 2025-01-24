import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""

    var body: some View {
        VStack {
            SearchBarView(city: $city) { citySearched in
                viewModel.fetchWeather(for: citySearched)
            }

            switch viewModel.state {
            case .searched:
                weatherContent
            case .saved:
                if viewModel.savedCity != nil {
                    savedCityContent
                } else {
                    defaultContent
                }
            case .error(let error):
                errorContent(error)
            case .loading:
                loadingContent
            case .idle:
                defaultContent
            }

            Spacer()
        }
        .onChange(of: city) { _, _ in
            if city.isEmpty {
                viewModel.updateViewState(.saved)
            }
        }
        .onAppear {
            viewModel.loadLastCityWeather()
        }
        .dismissKeyboardOnTap()
        .padding()
    }
}

extension HomeView {
    @ViewBuilder
    private var weatherContent: some View {
        if let weather = viewModel.weather {
            Spacer()
            WeatherInfoView(weather: weather)
        }
    }
}

extension HomeView {
    @ViewBuilder
    private var savedCityContent: some View {
        if let cityWeather = viewModel.savedCity {
            CityListView(cityWeather: cityWeather)
                .padding(.top, 32)
        }
    }
}

extension HomeView {
    @ViewBuilder
    private func errorContent(_ errorMessage: String) -> some View {
        Spacer()
        Text("Error: \(errorMessage)")
            .foregroundColor(.red)
            .padding()
    }
}

extension HomeView {
    @ViewBuilder
    private var loadingContent: some View {
        Spacer()
        ProgressView()
            .padding()
    }
}

extension HomeView {
    @ViewBuilder
    private var defaultContent: some View {
        Spacer()
        VStack {
            Text("No City Selected")
                .font(.system(size: 30, weight: .bold))
            Text("Please Search For A City")
                .font(.system(size: 15, weight: .bold))
        }
    }
}

#Preview {
    HomeView()
}
