import XCTest
@testable import Forecast

@MainActor
final class ForecastPresenterTests: XCTestCase {
    
    // MARK: - SUT
    
    private func makeSUT() -> (
        presenter: ForecastPresenter,
        view: MockForecastView,
        network: MockNetworkService,
        location: MockLocationService,
        mapper: MockForecastMapper
    ) {
        let view = MockForecastView()
        let network = MockNetworkService()
        let location = MockLocationService()
        let mapper = MockForecastMapper()
        
        let presenter = ForecastPresenter(
            dependencies: .init(
                networkService: network,
                locationService: location,
                mapper: mapper
            ),
            view: view
        )
        
        return (presenter, view, network, location, mapper)
    }
    
    // MARK: - Tests
    
    func test_successFlow() async {
        let (presenter, view, network, location, mapper) = makeSUT()
        
        // Arrange
        network.result = .success(ForecastResponse(days: []))
        location.locationResult = .success(
            LocationCoordinate(latitude: 0, longitude: 0)
        )
        mapper.mappedModel = .empty
        
        // Act
        await presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(view.didShowLoading)
        XCTAssertTrue(view.didHideLoading)
        XCTAssertNotNil(view.displayedForecast)
        XCTAssertNil(view.displayedError)
    }
    
    func test_locationError_usesFallback() async {
        let (presenter, view, network, location, _) = makeSUT()
        
        // Arrange
        network.result = .success(ForecastResponse(days: []))
        location.locationResult = .failure(LocationError.denied)
        
        // Act
        await presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(view.didShowLoading)
        XCTAssertTrue(view.didHideLoading)
        XCTAssertNotNil(view.displayedForecast)
        XCTAssertNil(view.displayedError)
    }
    
    func test_networkError_showsError() async {
        let (presenter, view, network, location, _) = makeSUT()
        
        // Arrange
        network.result = .failure(NetworkError.invalidResponse)
        location.locationResult = .success(
            LocationCoordinate(latitude: 0, longitude: 0)
        )
        
        // Act
        await presenter.viewDidLoad()
        
        // Assert
        XCTAssertTrue(view.didShowLoading)
        XCTAssertTrue(view.didHideLoading)
        XCTAssertNotNil(view.displayedError)
        XCTAssertNil(view.displayedForecast)
    }
}
