//
//  YBStationListTableViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/25.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

protocol YBStationListTableViewControllerDelegate: class {
    
    func stationListTableViewController(controller: YBStationListTableViewController, refresh sender: AnyObject?)
    
    func stationListTableViewController(controller: YBStationListTableViewController, stationDidSelect selectedStation: YBStationModel)
    
}

class YBStationListTableViewController: BaseTableViewController {

    struct Static {
        static let Identifier = "YBStationListTableViewController"
    }
    
    var stations: [YBStationModel] = []
    
    weak var delegate: YBStationListTableViewControllerDelegate?
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }

}


// MARK: - View Life Cycle

extension YBStationListTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension YBStationListTableViewController {
    
    private func setup() {
        
        let identifier = YBStationTableViewCell.Static.Identifier
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: identifier)
        
        tableView.separatorStyle = .None
        tableView.backgroundColor = .clearColor()
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .whiteColor()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        
    }
    
}


// MARK: - Action

extension YBStationListTableViewController {
    
    @objc private func refresh(sender: AnyObject?) { delegate?.stationListTableViewController(self, refresh: sender) }
    
}


// MARK: - UITableViewDataSource

extension YBStationListTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return stations.count }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return YBStationTableViewCell.Static.Height }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = YBStationTableViewCell.Static.Identifier
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YBStationTableViewCell
        let station = stations[indexPath.row]
        
        cell.nameLabel.text = station.name
        cell.addressLabel.text = station.address
        cell.numberOfRemainingBikes = station.numberOfRemainingBikes
        cell.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone: cell.viewMapButton.hidden = false
        default: cell.viewMapButton.hidden = true
        }
        
        return cell
        
    }
    
}


// MARK: - UITableViewDelegate

extension YBStationListTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedStation = stations[indexPath.row]
        let stationTableViewController = YBStationTableViewController()
        
        stationTableViewController.station = selectedStation
        stationTableViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(stationTableViewController, animated: true)
        
        delegate?.stationListTableViewController(self, stationDidSelect: selectedStation)
        
    }
    
}


// MARK: - YBStationTableViewCellDelegate

extension YBStationListTableViewController: YBStationTableViewCellDelegate {
    
    func stationTableViewCell(cell: YBStationTableViewCell, viewMap sender: AnyObject?) {
        
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        let station = stations[indexPath.row]
        let stationMapViewController = YBStationMapViewController.controller()
        stationMapViewController.stationAnnotation = YBStationAnnotation(station: station)
        stationMapViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(stationMapViewController, animated: true)
        
    }
    
}
