// swiftlint:disable comma
import UIKit
import Foundation
import SDWebImage
class DeliveryTblCell: UITableViewCell {
    var deliveryData: DeliveryModel? {
        didSet {
            productImage.sd_setImage(with: URL(string:
                deliveryData?.imageURL ?? ""), placeholderImage: UIImage(named: "placeHolder"),
                options: .refreshCached, context: nil)
            descriptionLbl.text = deliveryData?.deliveryDescription
        }
    }
    private let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    private let productImage: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 3.0
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.cornerRadius = 40.0
        imgView.clipsToBounds = true
        return imgView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(productImage)
        contentView.addSubview(descriptionLbl)
        addConstraintToViews()
    }
    func addConstraintToViews() {
        productImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = [
            "productImage": productImage,"descriptionLbl": descriptionLbl,
            "superview": contentView]
        let horizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[productImage(80)]-10-[descriptionLbl]-10-|",
            metrics: nil,
            views: views)
        contentView.addConstraints(horizontalConstraint)
        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(>=10)-[productImage(80)]-(>=10)-|",
            metrics: nil,
            views: views)
        contentView.addConstraints(imageVerticalConstraint)
        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[descriptionLbl]-10-|",
            metrics: nil,
            views: views)
        contentView.addConstraints(labelVerticalConstraint)
        productImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
