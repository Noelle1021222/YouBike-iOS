//
//  YBStationListCollectionViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/5/5.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import UIKit

protocol YBStationListCollectionViewControllerDelegate: class {
    
    func stationListCollectionViewController(controller: YBStationListCollectionViewController, refresh sender: AnyObject?)
    
    func stationListCollectionViewController(controller: YBStationListCollectionViewController, stationDidSelect selectedStation: YBStationModel)
    
}

class YBStationListCollectionViewController: BaseCollectionViewController {

    struct Static {
        static let Identifier = "YBStationListCollectionViewController"
        static let NumberOfColumns = 2
    }
    
    var stations: [YBStationModel] = []
    
    weak var delegate: YBStationListCollectionViewControllerDelegate?
    
}


// MARK: - View Life Cycle

extension YBStationListCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MAKR: - Setup

extension YBStationListCollectionViewController {
    
    private func setup() {
        
        collectionView!.backgroundColor = .clearColor()
        
        let identifier = YBStationCollectionViewCell.Static.Identifier
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView!.registerNib(nib, forCellWithReuseIdentifier: identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .whiteColor()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        
        collectionView!.addSubview(refreshControl)
        
        self.refreshControl = refreshControl
        
    }
    
}


// MARK: - Action

extension YBStationListCollectionViewController {
    
    @objc private func refresh(sender: AnyObject?) { delegate?.stationListCollectionViewController(self, refresh: sender) }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension YBStationListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfMargins = Static.NumberOfColumns + 1
        let width = (view.bounds.width - CGFloat(numberOfMargins) * YBStationCollectionViewCell.Static.Margin) / CGFloat(Static.NumberOfColumns)
        
        return CGSize(width: width, height: width)
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let margin = YBStationCollectionViewCell.Static.Margin
        
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    
    }
    
}


// MARK: - UICollectionViewDataSource

extension YBStationListCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return stations.count }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = YBStationCollectionViewCell.Static.Identifier
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! YBStationCollectionViewCell
        let station = stations[indexPath.row]
        
        cell.numberOfRemainingBikes = station.numberOfRemainingBikes
        cell.nameLabel.text = station.name
        
        return cell
        
    }
    
}


// MARK: - UICollectionViewDelegate

extension YBStationListCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectedStation = stations[indexPath.row]
        let stationTableViewController = YBStationTableViewController()
        
        stationTableViewController.station = selectedStation
        stationTableViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(stationTableViewController, animated: true)
        
        delegate?.stationListCollectionViewController(self, stationDidSelect: selectedStation)
        
    }
    
}


// MARK: - Initializer

extension YBStationListCollectionViewController {
    
    class func controller() -> YBStationListCollectionViewController { return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(Static.Identifier) as! YBStationListCollectionViewController }
    
}
