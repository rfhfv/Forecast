import UIKit

@MainActor
protocol ForecastPresenterProtocol: AnyObject {
    func viewDidLoad() async
}

@MainActor
protocol ForecastViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayForecast(_ viewModel: ForecastViewModel?)
    func displayError(_ message: String)
}

@MainActor
final class ForecastPresenter: ForecastPresenterProtocol {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
        let locationService: LocationServiceProtocol
        let mapper: ForecastMapperProtocol
    }
    
    private let dependencies: Dependencies
    private weak var view: ForecastViewProtocol?
    
    init(
        dependencies: Dependencies,
        view: ForecastViewProtocol
    ) {
        self.dependencies = dependencies
        self.view = view
    }
    
    func viewDidLoad() async {
        await loadForecast()
    }
    
    private func loadForecast() async {
        view?.showLoading()
        
        do {
            let location = try await dependencies.locationService.fetchLocation()
            let city = await dependencies.locationService.getCityName(from: location)
            let response = try await dependencies.networkService.fetchForecast(for: location)
            
            let viewModel = dependencies.mapper.map(
                response: response,
                city: city
            )
            
            view?.displayForecast(viewModel)
        } catch is LocationError {
            await loadFallbackForecast()
        } catch {
            view?.displayError(error.localizedDescription)
        }
        
        view?.hideLoading()
    }
    
    private func loadFallbackForecast() async {
        do {
            let response = try await dependencies.networkService.fetchForecast(
                for: .moscow
            )
            
            let viewModel = dependencies.mapper.map(
                response: response,
                city: Constants.Text.defaultCity
            )
            
            view?.displayForecast(viewModel)
        } catch {
            view?.displayError(Constants.Text.connectionError)
        }
    }
}
