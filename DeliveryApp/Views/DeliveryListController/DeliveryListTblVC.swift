// swiftlint:disable comma colon
import UIKit
class DeliveryListTblVC: UITableViewController {
    let tableEdgeInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    private var refresh = UIRefreshControl()
    var viewModel = DeliveryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ConstantMessage.homeTiltleText
        setupTableView()
        viewModel.showLoader = true
        setupDataHandler()
        viewModel.getListData()
    }
    fileprivate func setupTableView() {
        tableView.register(DeliveryTblCell.self, forCellReuseIdentifier: String(describing: DeliveryTblCell.self))
        tableView.separatorInset = tableEdgeInset
        tableView.backgroundColor = ColorConstant.tableBackGroundColor
        tableView.tableFooterView = UIView()
        addRefreshControl()
    }
    func setupDataHandler() {
        viewModel.reloadList = { [weak self] ()  in
            guard let weakSelfRefrence = self else {
                return
            }
            ///UI chnages in main tread
            DispatchQueue.main.async {
                weakSelfRefrence.tableView.reloadData()
                weakSelfRefrence.refresh.endRefreshing()
            }
        }
        viewModel.errorMessage = { [weak self] (message)  in
            guard let weakSelfRefrence = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelfRefrence.tableView.reloadData()
                weakSelfRefrence.refresh.endRefreshing()
            }
        }
    }

    func addActivityIndicatorOnFooterAndLoadMoreData() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.width, height: 60))
        view.backgroundColor = .clear
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge,color:.white,placeInTheCenterOf:view)
        activity.startAnimating()
        self.tableView.tableFooterView = view
        viewModel.getListData()
    }
}
// MARK: TableDataSource
extension DeliveryListTblVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DeliveryTblCell.self),for: indexPath) as? DeliveryTblCell {
            let model = viewModel.arrayOfDelivery[indexPath.row]
            cell.deliveryData = model
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfDelivery.count
    }
}

// MARK: TableDelegate
extension DeliveryListTblVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DeliveryDetailVC()
        detailVC.title = ConstantMessage.detailHeaderText
        let viewModelDetail = viewModel.arrayOfDelivery[indexPath.row]
        guard viewModelDetail.location != nil else {
            return
        }
        detailVC.deliveryDetailViewModel = DeliveryDetailViewModel(selectedDelivery: viewModelDetail)
        detailVC.view.backgroundColor = .white
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.arrayOfDelivery.count-1 {
            if viewModel.moreDataToLoad {
                addActivityIndicatorOnFooterAndLoadMoreData()
            } else {
                tableView.tableFooterView = UIView()
                tableView.tableFooterView?.removeFromSuperview()
            }
        }
    }
}

extension DeliveryListTblVC {

    private func addRefreshControl() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,.foregroundColor: UIColor.white,
            .strokeWidth: -2.0,.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        refresh = UIRefreshControl()
        refresh.tintColor = UIColor(red: 0.25,green: 0.72,blue: 0.85,alpha: 1.0)
        refresh.attributedTitle=NSAttributedString(string:ConstantMessage.refreshText,attributes: strokeTextAttributes)
        refresh.addTarget(self, action: #selector(refreshDeliveryData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
    }
    
    @objc private func refreshDeliveryData(_ sender: Any) {
        //this is for checking multiple call
        if viewModel.apiStatus == ApiState.apiInProgress { return }
        viewModel.offset = 0
        viewModel.showLoader = false
        viewModel.moreDataToLoad = true
        viewModel.getListData()
    }
}
