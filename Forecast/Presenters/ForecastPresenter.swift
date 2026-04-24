import UIKit

final class ForecastPresenter {
    private let networkService: NetworkService
    private let locationService: LocationService
    private let mapper: ForecastMapper
    
    weak var view: ForecastViewController?
    
    init(networkService: NetworkService,
         locationService: LocationService,
         mapper: ForecastMapper
    ) {
        self.networkService = networkService
        self.locationService = locationService
        self.mapper = mapper
    }
    
    func viewDidLoad() async {
        await loadForecast()
    }
}

private extension ForecastPresenter {
    func loadForecast() async {
        await MainActor.run {
            view?.showLoading()
        }
        do {
            let location = try await locationService.fetchLocation()
            let city = await locationService.getCityName(from: location)
            let response = try await networkService.fetchForecast(for: location)
            
            let viewModel = mapper.map(
                response: response,
                city: city
            )
            
            await MainActor.run {
                view?.displayForecast(viewModel)
            }
        } catch is LocationError {
            await loadFallbackForecast()
        } catch {
            await MainActor.run {
                view?.displayError(error.localizedDescription)
            }
        }
        
        await MainActor.run {
            view?.hideLoading()
        }
    }
    
    func loadFallbackForecast() async {
        do {
            let response = try await networkService.fetchForecast(
                for: .moscow
            )
            
            let viewModel = mapper.map(
                response: response,
                city: Constants.Text.defaultCity
            )
            
            await MainActor.run {
                view?.displayForecast(viewModel)
            }
        } catch {
            await MainActor.run {
                view?.displayError(Constants.Text.connectionError)
            }
        }
    }
}
