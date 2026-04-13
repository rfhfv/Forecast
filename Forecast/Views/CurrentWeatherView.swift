import UIKit

final class CurrentWeatherView: UIView {
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.medium.font, alignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.microscopic.font, textColor: .customSecondText, alignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.huge.font, alignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = Constants.Layout.Spacing.large
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var appearanceButton: UIButton = {
        let button = UIButton()
        button.tintColor = .customText
        updateThemeIcon(for: button)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CurrentForecastViewModel) {
        dateLabel.text = viewModel.dateTime
        cityLabel.text = viewModel.city
        tempLabel.text = "\(viewModel.temp)°"
        updateThemeIcon(for: appearanceButton)
    }
}

private extension CurrentWeatherView {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupActions() {
        appearanceButton.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
    }
    
    @objc func themeButtonTapped() {
        ThemeManager.shared.toggleTheme()
        updateThemeIcon(for: appearanceButton)
    }
    
    func updateThemeIcon(for button: UIButton) {
        let currentTheme = ThemeManager.shared.currentTheme
        let iconName = ThemeManager.shared.iconName(for: currentTheme)
        let configuration = UIImage.SymbolConfiguration(pointSize: Constants.Image.Size.small.height)
        button.setImage(UIImage(systemName: iconName, withConfiguration: configuration), for: .normal)
    }
    
    func setupViews() {
        addCustomSubviews(cityLabel, tempLabel, appearanceButton ,dateLabel, detailStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: appearanceButton.leadingAnchor, constant: Constants.Layout.Spacing.small),
            
            dateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: Constants.Layout.Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            appearanceButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.Spacing.small),
            appearanceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.Spacing.small),
            
            tempLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Layout.Spacing.small),
            tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor,  constant: -Constants.Layout.Spacing.small),
            tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
