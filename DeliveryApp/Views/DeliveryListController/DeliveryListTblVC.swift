// swiftlint:disable comma colon
import UIKit
class DeliveryListTblVC: UITableViewController {
    let tableEdgeInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    let footerHeight :  CGFloat = 60
    private var refresh = UIRefreshControl()
    var viewModel : DeliveryListModelProtocol = DeliveryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ConstantMessage.homeTiltleText
        setupTableView()
        viewModel.setShowLoader(show: true)
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
        viewModel.reloadListDataHandler = { [weak self] ()  in
            guard let weakSelfRefrence = self else {
                return
            }
            ///UI chnages in main tread
            DispatchQueue.main.async {
                weakSelfRefrence.tableView.reloadData()
                weakSelfRefrence.refresh.endRefreshing()
            }
        }
        viewModel.errorHandler = { [weak self] (error)  in
            guard let weakSelfRefrence = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelfRefrence.tableView.reloadData()
                weakSelfRefrence.refresh.endRefreshing()
            }
        }

        viewModel.noConnectivityHandler = { [weak self] (msg)  in
            guard let weakSelfRefrence = self else {
                return
            }
            DispatchQueue.main.async {
                Alert.shared.show(weakSelfRefrence, alert: ConstantMessage.checkConnectivity)
            }
        }
        viewModel.loadMoreCompletionHandler = { [weak self] (show) in
            guard let weakSelfRefrence = self else {
                return
            }
           DispatchQueue.main.async {
            guard show else {
                weakSelfRefrence.hideFooter()
                return
            }
            weakSelfRefrence.addActivityIndicatorOnFooterAndLoadMoreData()
         }
      }
   }
    private func hideFooter() {
        tableView.tableFooterView = UIView()
    }

    func addActivityIndicatorOnFooterAndLoadMoreData() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width:tableView.frame.width, height: footerHeight))
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
            cell.configureUI(indexPath: indexPath, viewModel: viewModel)
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
}

// MARK: TableDelegate
extension DeliveryListTblVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DeliveryDetailVC()
        guard viewModel.getLocation(index: indexPath).latitude != 0 && viewModel.getLocation(index: indexPath).longitude != 0 else {
            return
        }
        detailVC.deliveryDetailViewModel = DeliveryDetailViewModel(selectedDelivery: viewModel.getDeliveryModel(index: indexPath))
        detailVC.view.backgroundColor = .white
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
            viewModel.loadMoreApiCallInProgress(indexPath: indexPath)
    }
}

extension DeliveryListTblVC {

    private func addRefreshControl() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,.foregroundColor: UIColor.white,
            .strokeWidth: -2.0,.font: FontConstant.titleFont
        ]
        refresh = UIRefreshControl()
        refresh.tintColor = ColorConstant.activityIndicatorTintColor
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
        if viewModel.getApiState() == ApiState.apiInProgress { return }
           viewModel.apiCallForPullDownToRefresh()
    }
}
