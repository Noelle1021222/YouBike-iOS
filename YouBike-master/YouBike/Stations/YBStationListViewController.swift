//
//  YBStationListViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import PureLayout

protocol YBStationListViewControllerDelegate: class {
    
    func stationListViewController(controller: YBStationListViewController, stationDidSelect selectedStation: YBStationModel)
    
}

class YBStationListViewController: BaseViewController {

    struct Static {
        static let Identifier = "YBStationListViewController"
        static let Title = NSLocalizedString("YouBike", comment: "")
    }
    
    private lazy var switcherView: YBStationViewModeSwitcherView = { [unowned self] in
        
        let view = YBStationViewModeSwitcherView()
        
        view.addTarget(self, action: #selector(switchViewMode(_:)), forControlEvents: .ValueChanged)
        
        return view
        
    }()
    
    private(set) var stations: [YBStationModel] = [] { didSet { stationsDidSet() } }
    
    private lazy var stationListTableViewController: YBStationListTableViewController = { [unowned self] in
        
        let controller = YBStationListTableViewController()
        
        controller.delegate = self
        
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        
        return controller
        
    }()

    private lazy var stationListCollectionViewController: YBStationListCollectionViewController = { [unowned self] in
    
        let controller = YBStationListCollectionViewController.controller()
        
        controller.delegate = self
        
        self.addChildViewController(controller)
        self.didMoveToParentViewController(controller)
        
        return controller
    
    }()
    
    private var next: String?
    private var isLoaded = false
    
    weak var delegate: YBStationListViewControllerDelegate?
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBStationListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if stations.isEmpty {
            
            stationListTableViewController.beginPullToRefresh()
            stationListCollectionViewController.beginPullToRefresh()
            
            getStationsData()
            
        }
        
    }
    
}


// MARK: - Setup

extension YBStationListViewController {
    
    private func setup() {
        
        isLoaded = true
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Pad:
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab-bar-profile")!, style: .Plain, target: self, action: #selector(showProfile(_:)))
            
        default: break
        }
        
        view.backgroundColor = YBColor.Color5
        
        navigationItem.title = Static.Title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switcherView)
        
        switchViewMode(nil)
        
    }
    
}


// MAKR: - Action

extension YBStationListViewController {
    
    @objc private func switchViewMode(sender: AnyObject?) {
        
        stationListTableViewController.view.removeFromSuperview()
        stationListCollectionViewController.view.removeFromSuperview()
        
        switch switcherView.selectedItem {
        case .List:
            
            let contentView = stationListTableViewController.view
            view.addSubview(contentView)
            
            contentView.autoPinEdgesToSuperviewEdges()
            
        case .Grid:
            
            let contentView = stationListCollectionViewController.view
            view.addSubview(contentView)
            
            contentView.autoPinEdgesToSuperviewEdges()
        }
        
    }
    
    // todo: synchronize the scroll position between table view and collection based on top nearest station.
    
    @objc private func showProfile(sender: AnyObject?) {
        
        let profileViewController = YBProfileViewController.controller()
        let navigationController = YBNavigationController(rootViewController: profileViewController)
        
        navigationController.modalPresentationStyle = .Popover
        navigationController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        
        presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
}


// MARK: - Observer

extension YBStationListViewController {
    
    private func stationsDidSet() {
        
        if !isLoaded { return }
        
        if next == nil {
            
            stationListTableViewController.removeInfinityScroll()
            stationListCollectionViewController.removeInfinityScroll()
        
        }
        else {
            
            stationListTableViewController.addInfinityScroll(activityIndicatorStyle: .White) { [unowned self] in self.getMoreStations() }
            
            stationListCollectionViewController.addInfinityScroll(activityIndicatorStyle: .White) { [unowned self] in self.getMoreStations() }
            
        }
        
        stationListTableViewController.stations = stations
        stationListTableViewController.tableView.reloadData()
        
        stationListCollectionViewController.stations = stations
        stationListCollectionViewController.collectionView?.reloadData()
        
    }
    
}


// MARK: - Data

extension YBStationListViewController {
    
    private func getStationsData() {
        
        YBStationManager.sharedManager.getStations(
            success: { [weak self] result in
                
                guard let weakSelf = self else { return }
                
                weakSelf.stationListTableViewController.endPullToRefresh()
                weakSelf.stationListCollectionViewController.endPullToRefresh()
                
                weakSelf.next = result.next
                weakSelf.stations = result.stations
                
            },
            failure: { [weak self] error in
                
                guard let weakSelf = self else { return }
                
                weakSelf.stationListTableViewController.endPullToRefresh()
                weakSelf.stationListCollectionViewController.endPullToRefresh()
                
            }
        )
        
    }
    
    private func getMoreStations() {
        
        guard let next = next where !next.isEmpty else {
            
            stationListTableViewController.endInfinityScroll(completion: nil)
            stationListCollectionViewController.endInfinityScroll(completion: nil)
            
            return
        
        }
        
        YBStationManager.sharedManager.getMoreStations(
            paging: next,
            success: { [weak self] result in
                
                guard let weakSelf = self else { return }
                
                weakSelf.stationListTableViewController.endInfinityScroll(completion: nil)
                weakSelf.stationListCollectionViewController.endInfinityScroll(completion: nil)
                
                weakSelf.next = result.next
                weakSelf.stations += result.stations
                
            },
            failure: { [weak self] _ in
                
                guard let weakSelf = self else { return }
                
                weakSelf.stationListTableViewController.endInfinityScroll(completion: nil)
                weakSelf.stationListCollectionViewController.endInfinityScroll(completion: nil)
                
            }
        )
        
    }
    
}


// MARK: - YBStationListTableViewControllerDelegate

extension YBStationListViewController: YBStationListTableViewControllerDelegate {
    
    func stationListTableViewController(controller: YBStationListTableViewController, refresh sender: AnyObject?) { getStationsData() }
    
    func stationListTableViewController(controller: YBStationListTableViewController, stationDidSelect selectedStation: YBStationModel) { delegate?.stationListViewController(self, stationDidSelect: selectedStation) }
    
}


// MARK: - YBStationListCollectionViewControllerDelegate

extension YBStationListViewController: YBStationListCollectionViewControllerDelegate {
    
    func stationListCollectionViewController(controller: YBStationListCollectionViewController, refresh sender: AnyObject?) { getStationsData() }
    
    func stationListCollectionViewController(controller: YBStationListCollectionViewController, stationDidSelect selectedStation: YBStationModel) { delegate?.stationListViewController(self, stationDidSelect: selectedStation) }
    
}
