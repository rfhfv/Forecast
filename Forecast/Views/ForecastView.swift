import UIKit

protocol ForecastViewProtocol: AnyObject {
    var onRetry: (() -> Void)? { get set }
    var onRefresh: (() -> Void)? { get set }
    
    func showLoading()
    func hideLoading()
    func displayForecast(_ viewModel: ForecastViewModel)
    func displayError(_ message: String)
}

final class ForecastView: UIView {
    private let currentWeatherView = CurrentWeatherView()
    private var viewModel: ForecastViewModel?
    
    var onRetry: (() -> Void)?
    var onRefresh: (() -> Void)?
    
    private enum Section: Int, CaseIterable {
        case hourly
        case details
        case daily
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.identifier)
        collection.register(DetailsCell.self, forCellWithReuseIdentifier: DetailsCell.identifier)
        collection.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.identifier)
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator =  UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Layout.Spacing.extraLarge
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ForecastView: ForecastViewProtocol {
    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorContainer.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        scrollView.refreshControl?.endRefreshing()
    }
    
    func displayForecast(_ viewModel: ForecastViewModel) {
        showContent(with: viewModel)
    }
    
    func displayError(_ message: String) {
        showError(message)
    }
}

private extension ForecastView {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupRefrechControl()
        setupActions()
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
        currentWeatherView.configure(with: viewModel.current)
        scrollView.isHidden = false
        errorContainer.isHidden = true
        loadingIndicator.stopAnimating()
        collectionView.reloadData()
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
        onRefresh?()
    }
    
    @objc func retryTapped() {
        onRetry?()
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
            widthDimension: .absolute(Constants.Grid.Size.itemSize.width),
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
            widthDimension: .absolute(Constants.Grid.Size.itemSize.width),
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
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        
        addCustomSubviews(scrollView, contentView, loadingIndicator, errorContainer)
        contentView.addCustomSubviews(currentWeatherView, collectionView)
        
        scrollView.addSubview(contentView)
        errorContainer.addCustomArrangedSubviews(errorLabel, retryButton)
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
            
            currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.large),
            currentWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.Spacing.large),
            
            collectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
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
