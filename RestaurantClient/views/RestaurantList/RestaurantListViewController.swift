//
//  RestaurantListViewController.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import UIKit

final class RestaurantListViewController: UIViewController {
    
    enum Constants {
        static let title = "Restaurant list"
    }
    
    var tableView: UITableView!
    private(set) var viewModel: RestaurantListViewModelProtocol
    
    init(viewModel: RestaurantListViewModelProtocol = RestaurantListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        self.view = view
        tableView = UITableView()
        self.view.addFullSizeSubview(view: tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Constants.title
        self.navigationController?.navigationBar.tintColor = .black
        
        setupTableView()
        setupViewModel()
        setupSortFeature()
    }
    
    private func setupTableView() {
        tableView.register(RestaurantListCell.self, forCellReuseIdentifier: RestaurantListCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        tableView.dataSource = self
    }
    
    private func setupViewModel() {
        viewModel.showError = { error in
            
        }
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.start()
    }
    
    private func setupSortFeature() {
        let image = UIImage(named: "sort")
        let sortButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sortButtonTapped))
        self.navigationItem.setRightBarButton(sortButton, animated: true)
    }
    
    @objc func sortButtonTapped() {
        let alertController = UIAlertController(title: "Sort", message: "", preferredStyle: .actionSheet)
        let actionByName = UIAlertAction(title: "by Name", style: .default) { [weak self] alertAction in
            self?.viewModel.setSortOption(.name)
        }
        let actionByRating = UIAlertAction(title: "by Rating", style: .default) { [weak self] alertAction in
            self?.viewModel.setSortOption(.rating)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(actionByName)
        alertController.addAction(actionByRating)
        alertController.addAction(actionCancel)
        
        self.present(alertController, animated: true)
        
    }
    
}

// Mark: - DataSourceMethods
extension RestaurantListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.restaurantCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListCell.reuseIdentifier) as? RestaurantListCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(viewModel: viewModel.getCellViewModel(indexPath: indexPath))
        cell.selectionStyle = .none
        
        return cell
    }
}
