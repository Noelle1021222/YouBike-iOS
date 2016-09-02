//
//  YBStationMapTableViewCell.swift
//  YouBike
//
//  Created by 許郁棋 on 2016/4/27.
//  Copyright © 2016年 Tiny World. All rights reserved.
//

import PureLayout

class YBStationMapTableViewCell: UITableViewCell {

    struct Static {
        static let Identifier = "YBStationMapTableViewCell"
        static let Height: CGFloat = 250.0
    }
    
    private var mapView: UIView?
    
}


// MARK: - Setup

extension YBStationMapTableViewCell {
    
    func setup(mapView mapView: UIView) {
        
        self.mapView?.removeFromSuperview()
        
        addSubview(mapView)
        mapView.autoPinEdgesToSuperviewEdges()
        
        mapView.userInteractionEnabled = false
        
        self.mapView = mapView
        
    }
    
}
