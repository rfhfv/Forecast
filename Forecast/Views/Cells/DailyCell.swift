import UIKit

final class DailyCell: UICollectionViewCell {
    static let identifier = String(describing: DailyCell.self)
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.tiny.font, textColor: .customSecondText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.small.font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for viewModel: ForecastDayViewModel) {
        dayLabel.text = viewModel.dateTime
        tempLabel.text = "\(viewModel.tempMin)°/\(viewModel.tempMax)°"
    }
}

private extension DailyCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addCustomSubviews(dayLabel, tempLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.medium),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: Constants.Layout.Spacing.medium),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.medium),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
