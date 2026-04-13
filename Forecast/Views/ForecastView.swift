import UIKit

protocol WeatherViewDelegate: AnyObject {
    func didTapRetry()
    func didRefresh()
}

final class ForecastView: UIView {
    struct Dependencies {
        let currentWeatherView: CurrentWeatherView
        
        static func makeDefault() -> Dependencies {
            Dependencies(
                currentWeatherView: CurrentWeatherView())
        }
    }
    
    private enum Section: Int, CaseIterable {
        case hourly
        case details
        case daily
    }
    
    private var viewModel: ForecastViewModel?
    
    private let dependencies: Dependencies
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.identifier)
        collection.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.identifier)
        collection.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.identifier)
        collection.backgroundColor = .clear
        collection.dataSource = self
        return collection
    }()
    
    private let errorContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Layout.Spacing.extraLarge
        stack.alignment = .center
        return stack
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.small.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Text.retry, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = Constants.Layout.Size.cornerRadius
        button.backgroundColor = .customButtonBackground
        button.setTitleColor(.customButtonText, for: .normal)
        button.titleLabel?.font = Typography.small.font
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: WeatherViewDelegate?
    
    init(dependencies: Dependencies = .makeDefault()) {
        self.dependencies = dependencies
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorContainer.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        scrollView.refreshControl?.endRefreshing()
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        scrollView.isHidden = true
        errorContainer.isHidden = false
        loadingIndicator.stopAnimating()
        scrollView.refreshControl?.endRefreshing()
    }
    
    func showContent(with viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        scrollView.isHidden = false
        errorContainer.isHidden = true
        loadingIndicator.stopAnimating()
        
        dependencies.currentWeatherView.configure(with: viewModel.current)
        collectionView.reloadData()
    }
}

private extension ForecastView {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupRefrechControl()
        setupActions()
    }
    
    func setupRefrechControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    func setupActions() {
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }
    
    @objc func handleRefresh() {
        delegate?.didRefresh()
    }
    
    @objc func retryTapped() {
        delegate?.didTapRetry()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .hourly: return self?.createHourlySection()
            case .details: return self?.createDetailsSection()
            case .daily: return self?.createDailySection()
            }
        }
    }
    
    func createHourlySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.Grid.Size.itemSize.width),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.Grid.Size.horizontalWidth),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = Constants.Grid.Spacing.hourlySectionInsets
        
        return section
    }
    
    func createDetailsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.Grid.Spacing.sectionInsets
        
        return section
    }
    
    func createDailySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.Grid.Size.itemSize.width),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.Grid.Size.horizontalWidth),
            heightDimension: .absolute(Constants.Grid.Size.itemSize.height)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = Constants.Grid.Spacing.sectionInsets
        
        return section
    }
    
    func setupViews() {
        backgroundColor = .customBackground
        
        [scrollView, contentView, loadingIndicator, errorContainer].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [dependencies.currentWeatherView, collectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        errorContainer.addArrangedSubview(errorLabel)
        errorContainer.addArrangedSubview(retryButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.Spacing.large),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Constants.Layout.Spacing.large),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dependencies.currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dependencies.currentWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.large),
            dependencies.currentWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.Spacing.large),
            
            collectionView.topAnchor.constraint(equalTo: dependencies.currentWeatherView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Layout.Spacing.large),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.Layout.Size.collectionHeight),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.Layout.Spacing.large),
            errorContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.Spacing.large),
            errorContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.Spacing.large),
            
            retryButton.heightAnchor.constraint(equalToConstant: Constants.Layout.Size.button.height),
            retryButton.widthAnchor.constraint(equalToConstant: Constants.Layout.Size.button.width)
        ])
    }
}

extension ForecastView: ForecastViewProtocol {
    func displayForecast(_ viewModel: ForecastViewModel?) {
        guard let model = viewModel else { return }
        showContent(with: model)
    }
    
    func displayError(_ message: String) {
        showError(message)
    }
}

extension ForecastView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section),
              let viewModel = viewModel else { return 0 }
        
        switch section {
        case .hourly: return viewModel.hourly.count
        case .details: return viewModel.details.detailsCount
        case .daily: return viewModel.daily.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section),
              let viewModel = viewModel else { return UICollectionViewCell() }
        
        switch section {
        case .hourly:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.identifier, for: indexPath) as? HourlyCell else { return UICollectionViewCell() }
            
            cell.configure(with: viewModel.hourly[indexPath.item])
            return cell
            
        case .details:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCell.identifier, for: indexPath) as? DetailsCell else { return UICollectionViewCell() }
            let item = viewModel.details.toDetailItems()[indexPath.item]
            cell.configure(for: item)
            return cell
            
        case .daily:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.identifier, for: indexPath) as? DailyCell else { return UICollectionViewCell() }
            
            cell.configure(for: viewModel.daily[indexPath.item])
            return cell
        }
    }
}
