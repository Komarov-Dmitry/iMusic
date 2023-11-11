//
//  SearchModels.swift
//  iMusic
//
//  Created by Комаров Дмитрий  on 03.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SwiftUI

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getTracks(serchText: String)
      }
    }
    struct Response {
      enum ResponseType {
          case presentTracks(searchResponse: SearchResponse?)
          case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayTracks(searchViewModel:SearchViewModel)
          case displayFooterView
      }
    }
  }
  
}

class SearchViewModel: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
    }
    
    @objc(_TtCC6iMusic15SearchViewModel4Cell)class Cell: NSObject, NSCoding, Identifiable {
        
        var id = UUID()
        
        func encode(with coder: NSCoder) {
            coder.encode(iconUrlString, forKey: "iconUrlString")
            coder.encode(trackName, forKey: "trackName")
            coder.encode(collectionName, forKey: "collectionName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String? ?? ""
            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
            collectionName = coder.decodeObject(forKey: "collectionName") as? String? ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String? ?? ""
        }
        
        
        var iconUrlString: String?
        var trackName: String
        var collectionName: String?
        var artistName: String
        var previewUrl: String?
        
        init(iconUrlString: String? = nil, 
             trackName: String,
             collectionName: String? = nil,
             artistName: String,
             previewUrl: String? = nil) {
            
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.collectionName = collectionName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
    }
    init(cells: [Cell]) {
        self.cells = cells
    }
    let cells: [Cell]
}
