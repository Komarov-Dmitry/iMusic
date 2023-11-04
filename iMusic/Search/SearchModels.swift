//
//  SearchModels.swift
//  iMusic
//
//  Created by Комаров Дмитрий  on 03.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

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

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        
        var iconUrlString: String?
        var trackName: String
        var collectionName: String?
        var artistName: String
        var previewUrl: String?
    }
    let cells: [Cell]
}
