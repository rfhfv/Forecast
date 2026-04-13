import Foundation
@testable import Forecast

final class MockForecastMapper: ForecastMapperProtocol {
    var mappedModel: ForecastViewModel = .empty
    
    func map(response: ForecastResponse, city: String) -> ForecastViewModel {
        return mappedModel
    }
}
