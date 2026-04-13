import UIKit

final class HourlyCell: UICollectionViewCell {
    static let identifier = String(describing: HourlyCell.self)
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.tiny.font, textColor: .customSecondText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .customSecondText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    func configure(with viewModel: ForecastHourViewModel) {
        timeLabel.text = viewModel.datetime
        tempLabel.text = "\(viewModel.temp)°"
        iconImageView.image = viewModel.icon.image
    }
}

private extension HourlyCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addCustomSubviews(timeLabel, iconImageView, tempLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Constants.Layout.Spacing.medium),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.Image.Size.small.height),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.Image.Size.small.width),
            
            tempLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.Layout.Spacing.medium),
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
