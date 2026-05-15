import UIKit

protocol ForecastPresenterProtocol: AnyObject {
    func fetchForecast() async
}

final class ForecastPresenter {
    private let networkService: NetworkServiceProtocol
    private let locationService: LocationServiceProtocol
    private let mapper: ForecastMapperProtocol
    
    weak var view: ForecastViewProtocol?
    
    init(networkService: NetworkServiceProtocol,
         locationService: LocationServiceProtocol,
         mapper: ForecastMapperProtocol
    ) {
        self.networkService = networkService
        self.locationService = locationService
        self.mapper = mapper
    }
}

extension ForecastPresenter: ForecastPresenterProtocol {
    func fetchForecast() async {
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
