//
//  YBStationTableViewController.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import SDWebImage

class YBStationTableViewController: BaseTableViewController {

    struct Static {
        static let Identifier = "YBStationTableViewController"
    }
    
    enum Section {
        
        case Information, Map, Comments
        
        var title: String {
            
            switch self {
            case .Information: return ""
            case .Map: return ""
            case .Comments: return NSLocalizedString("Comments", comment: "")
            }
            
        }
    
    }
    
    private var sections: [Section] = []
    
    private lazy var stationMapViewController: YBStationMapViewController = { [unowned self] in
        
        let stationMapViewController = YBStationMapViewController.controller()
        
        stationMapViewController.hidesBottomView = true
        
        self.addChildViewController(stationMapViewController)
        self.didMoveToParentViewController(stationMapViewController)
        
        return stationMapViewController
        
    }()
    
    var station: YBStationModel? { didSet { stationDidSet() } }
    
    private(set) var comments: [YBCommentModel] = [] { didSet { commentsDidSet() } }
    private var next: String?
    
    
    // MARK: - Deinit
    
    deinit {
        
        let functionName = "deinit"
        let identifier = "[\(Static.Identifier)] \(functionName)"
        print("\(identifier): released.")
        
    }
    
}


// MARK: - View Life Cycle

extension YBStationTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


// MARK: - Setup

extension YBStationTableViewController {
    
    private func setup() {
        
        let identifiers = [
            YBStationTableViewCell.Static.Identifier,
            YBStationMapTableViewCell.Static.Identifier,
            YBCommentTableViewCell.Static.Identifier
        ]
        
        for identifier in identifiers {
            
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: identifier)
            
        }
        
        tableView.separatorStyle = .None
        tableView.backgroundColor = YBColor.Color5
        
    }
    
}


// MARK: - Observer

extension YBStationTableViewController {
    
    private func stationDidSet() {
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone: sections = (station == nil) ? [] : [ .Information, .Map, .Comments ]
        default: sections = (station == nil) ? [] : [ .Information, .Comments ]
        }
        
        navigationItem.title = station?.name
        
        tableView.reloadData()
        
        getComments()
        
    }
    
    private func commentsDidSet() {
        
        if next == nil { removeInfinityScroll() }
        else {
            
            addInfinityScroll(activityIndicatorStyle: .White) { [unowned self] in self.getMoreComments() }
            
        }
        
        tableView.reloadData()
        
    }
    
}


// MARK: - Action

extension YBStationTableViewController {
    
    private func getComments() {
        
        guard let station = station else { return }
        
        YBStationManager.sharedManager.getCommentsForStation(
            stationID: station.identifier,
            success: { [weak self] result in
                
                guard let weakSelf = self else { return }
                
                weakSelf.next = result.next
                weakSelf.comments = result.comments
                weakSelf.tableView.reloadData()
                
            },
            failure: nil
        )
        
    }
    
    private func getMoreComments() {
        
        guard let stationID = station?.identifier,
            let next = next
            where !stationID.isEmpty && !next.isEmpty
            else {
        
            endInfinityScroll(completion: nil)
            
            return
        
        }
        
        YBStationManager.sharedManager.getMoreCommentsForStation(
            stationID: stationID,
            paging: next,
            success: { [weak self] result in
                
                guard let weakSelf = self else { return }
                
                weakSelf.endInfinityScroll(completion: nil)
                
                weakSelf.next = result.next
                weakSelf.comments += result.comments
                
            },
            failure: { [weak self] _ in self?.endInfinityScroll(completion: nil) }
        )
        
    }
    
}


// MARK: - UITableViewDataSource

extension YBStationTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return sections.count }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch sections[section] {
        case .Comments:
            
            let headerView = YBStationSectionHeaderView.view()
            headerView.titleLabel.text = sections[section].title
            
            return headerView
            
        case .Information, .Map: return nil
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch sections[section] {
        case .Comments: return YBStationSectionHeaderView.Static.Height
        case .Information, .Map: return 0.0
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .Information, .Map: return 1
        case .Comments: return comments.count
        }
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 44.0 }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch sections[indexPath.section] {
        case .Information: return YBStationTableViewCell.Static.Height
        case .Map: return YBStationMapTableViewCell.Static.Height
        case .Comments: return UITableViewAutomaticDimension
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .Information:
            
            let identifier = YBStationTableViewCell.Static.Identifier
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YBStationTableViewCell
            
            if let station = station {
               
                cell.nameLabel.text = station.name
                cell.addressLabel.text = station.address
                cell.numberOfRemainingBikes = station.numberOfRemainingBikes
                
            }
            
            cell.viewMapButton.hidden = true
            
            return cell
        
        case .Map:
            
            let identifier = YBStationMapTableViewCell.Static.Identifier
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YBStationMapTableViewCell
            let mapView = stationMapViewController.view
            
            if let station = station {
                
                stationMapViewController.stationAnnotation = YBStationAnnotation(station: station)
                
            }
            
            cell.setup(mapView: mapView)
            
            return cell
        
        case .Comments:
            
            let identifier = YBCommentTableViewCell.Static.Identifier
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! YBCommentTableViewCell
            let comment = comments[indexPath.row]
            
            if let profileImageURL = comment.user.profileImageURL {
                
                cell.profileImageView.sd_setImageWithURL(profileImageURL, placeholderImage: nil, options: .RefreshCached)
                
            }
            
            cell.nameLabel.text = comment.user.name
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            cell.dateLabel.text = dateFormatter.stringFromDate(comment.createdDate)
            
            cell.commentLabel.text = comment.text
            
            return cell
            
        }
        
    }
    
}


// MARK: - UITableViewDelegate

extension YBStationTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch sections[indexPath.section] {
        case .Map:
            
            guard let station = station else { return }
            
            let stationMapViewController = YBStationMapViewController.controller()
            stationMapViewController.stationAnnotation = YBStationAnnotation(station: station)
            
            navigationController?.pushViewController(stationMapViewController, animated: true)
            
        case .Information, .Comments: break
        }
        
    }
    
}
