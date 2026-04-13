import UIKit

final class DetailsCell: UICollectionViewCell {
    static let identifier = String(describing: DetailsCell.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.tiny.font, textColor: .customSecondText, alignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.configure(font: Typography.large.font, alignment: .left)
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
    
    func configure(for item: DetailItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}

private extension DetailsCell {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addCustomSubviews(titleLabel, valueLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Layout.Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.large),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.Spacing.large),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Layout.Spacing.small),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.Spacing.large),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.Spacing.large),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
