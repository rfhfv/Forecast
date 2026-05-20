import Foundation
@testable import Forecast

final class MockForecastView: ForecastViewProtocol {
    var onRetry: (() -> Void)?
    var onRefresh: (() -> Void)?
    
    private(set) var didShowLoading = false
    private(set) var didHideLoading = false
    private(set) var displayedForecast: ForecastViewModel?
    private(set) var displayedError: String?
    
    func showLoading() {
        didShowLoading = true
    }
    
    func hideLoading() {
        didHideLoading = true
    }
    
    func displayForecast(_ viewModel: ForecastViewModel) {
        displayedForecast = viewModel
    }
    
    func displayError(_ message: String) {
        displayedError = message
    }
}
