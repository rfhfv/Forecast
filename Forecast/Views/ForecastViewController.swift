import UIKit

class ForecastViewController: UIViewController {
    struct Dependencies {
        let forecastView: ForecastView
        let presenter: ForecastPresenterProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = dependencies.forecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        
        Task {
            await  dependencies.presenter.viewDidLoad()
        }
    }
    
    private func setupDelegates() {
        dependencies.forecastView.delegate = self
    }
}

extension ForecastViewController: WeatherViewDelegate {
    func didTapRetry() {
        Task {
            await dependencies.presenter.viewDidLoad()
        }
    }
    
    func didRefresh() {
        Task {
            await dependencies.presenter.viewDidLoad()
        }
    }
}

@MainActor
extension ForecastViewController: ForecastViewProtocol {
    func showLoading() {
        dependencies.forecastView.showLoading()
    }
    
    func hideLoading() {
        dependencies.forecastView.hideLoading()
    }
    
    func displayForecast(_ viewModel: ForecastViewModel?) {
        dependencies.forecastView.displayForecast(viewModel)
    }
    
    func displayError(_ message: String) {
        dependencies.forecastView.displayError(message)
    }
}
