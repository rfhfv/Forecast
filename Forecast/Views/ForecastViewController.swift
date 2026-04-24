import UIKit

class ForecastViewController: UIViewController {
    private let forecastView: ForecastView
    private let output: ForecastPresenter
    
    init(output: ForecastPresenter, forecastView: ForecastView) {
        self.output = output
        self.forecastView = forecastView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = forecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        reload()
    }
    
    func showLoading() {
        forecastView.showLoading()
    }
    
    func hideLoading() {
        forecastView.hideLoading()
    }
    
    func displayForecast(_ viewModel: ForecastViewModel?) {
        forecastView.displayForecast(viewModel)
    }
    
    func displayError(_ message: String) {
        forecastView.displayError(message)
    }
}

private extension ForecastViewController {
    func setupActions() {
        forecastView.onRetry = { [weak self] in
            self?.reload()
        }
        
        forecastView.onRefresh = { [weak self] in
            self?.reload()
        }
    }
    
    func reload() {
        Task {
            await output.viewDidLoad()
        }
    }
}
