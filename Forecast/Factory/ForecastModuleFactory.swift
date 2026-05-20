import UIKit

protocol ForecastModuleFactoryProtocol {
    func makeForecastModule() -> UIViewController
}

final class ForecastModuleFactory: ForecastModuleFactoryProtocol {
    func makeForecastModule() -> UIViewController {
        let view = ForecastView()
        let network = NetworkService()
        let location = LocationService()
        let dateService = DateFormatterService()
        let mapper = ForecastMapper(dateService: dateService)
        
        let presenter = ForecastPresenter(
            networkService: network,
            locationService: location,
            mapper: mapper
        )
        
        let vc = ForecastViewController(output: presenter, forecastView: view)
        
        presenter.view = view
        
        return vc
    }
}
