//
//  DataModel.swift
//  OzdemirZ_RemoteControl3
//
//  Created by Zubeyir Ozdemir on 24/02/20.
//  Copyright © 2020 Zubeyir Ozdemir. All rights reserved.
//

import Foundation

struct FavoriteChannel {
    var label: String
    var channelNumber: Int
}

class DataModel {
    var favorites = [FavoriteChannel]()
    
    //this property is used to access current instance of this class
    static let shared: DataModel = {
        let instance = DataModel()
        return instance
    }()
    
    
    //this method calls when object of this class created
    init() {
        favorites = [
            FavoriteChannel(label: "ABC", channelNumber: 99),
            FavoriteChannel(label: "NBC", channelNumber: 98),
            FavoriteChannel(label: "CBS", channelNumber: 97),
            FavoriteChannel(label: "FOX", channelNumber: 96)
        ]
    }
}
