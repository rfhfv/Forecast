import UIKit

@MainActor
protocol ForecastModuleFactoryProtocol {
    func makeForecastModule() -> UIViewController
}

@MainActor
final class ForecastModuleFactory: ForecastModuleFactoryProtocol {
    func makeForecastModule() -> UIViewController {
        let view = ForecastView()
        
        let network = NetworkService()
        let location = LocationService()
        let dateService = DateFormatterService()
        let mapper = ForecastMapper(dateService: dateService)
        
        let presenter = ForecastPresenter(
            dependencies: .init(
                networkService: network,
                locationService: location,
                mapper: mapper
            ),
            view: view
        )
        
        let vc = ForecastViewController(
            dependencies: .init(
                forecastView: view,
                presenter: presenter
            )
        )
        
        return vc
    }
}
