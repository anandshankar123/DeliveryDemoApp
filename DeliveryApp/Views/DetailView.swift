// swiftlint:disable comma
import UIKit
import PureLayout
import GoogleMaps
import CoreLocation
class DetailView: UIView {
    let deliveryId = "Delivery Id"
    static let bottomViewHeight: CGFloat = 100
    var deliverDeatilModel: DeliveryDetailViewModel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   convenience init(frame: CGRect,model: DeliveryDetailViewModel) {
        self.init(frame: frame)
        self.deliverDeatilModel = model
        addSubviews()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var gmsMapView: GMSMapView = {
        let view = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude:deliverDeatilModel.getLatitude(), longitude:
            deliverDeatilModel.getLongitude(), zoom: 16))
        return view
    }()
    func showMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: deliverDeatilModel.getLatitude(),
            longitude: deliverDeatilModel.getLongitude())
        marker.title = deliverDeatilModel.getAddress()
        if deliverDeatilModel.getDeliveryIdAddress() != -1 {
            marker.snippet = deliveryId + " : \(deliverDeatilModel.getDeliveryIdAddress())"
        } else {
            marker.snippet = deliveryId + ":" + ConstantMessage.dataNotFound
        }
        marker.map = self.gmsMapView
    }
    lazy var bottomView: UIView = {
        let view = UIView()
        view.autoSetDimensions(to: CGSize(width: ScreenSize.screenWidth, height:
            DetailView.bottomViewHeight))
        view.backgroundColor = UIColor(displayP3Red: 24/255, green: 56/255, blue: 120/255, alpha: 1)
        return view
    }()
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string:
        deliverDeatilModel.getImageUrl()),placeholderImage: UIImage(named: "placeHolder"),options:
            .refreshCached,context: nil)
        imageView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 40.0
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        if deliverDeatilModel.getDeliveryText() != "" {
            lbl.text = deliverDeatilModel.getDeliveryText()
        } else {
            lbl.text = ConstantMessage.descriptionNotFound
        }
        lbl.textColor = .black
        lbl.textAlignment = NSTextAlignment.left
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        return lbl
    }()

    func setupConstraints() {
        gmsMapView.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        gmsMapView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 0)
        gmsMapView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 0)
        gmsMapView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
        bottomView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 0)
        bottomView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 0)
        bottomView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 0)
        productImage.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
        productImage.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
        descriptionLbl.autoAlignAxis(.horizontal, toSameAxisOf: productImage, withOffset: 0)
        descriptionLbl.autoPinEdge(.left, to: .right, of: productImage, withOffset: 16)
        descriptionLbl.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
    }
    override func updateConstraints() {
        // Insert code here
        super.updateConstraints() // Always at the bottom of the function
    }
    func addSubviews() {
        self.addSubview(gmsMapView)
        self.addSubview(bottomView)
        self.bottomView.addSubview(productImage)
        self.bottomView.addSubview(descriptionLbl)
        self.bringSubviewToFront(bottomView)
        self.layoutIfNeeded()
    }
}
