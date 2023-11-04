//
//  SearchInteractor.swift
//  iMusic
//
//  Created by Комаров Дмитрий  on 03.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
  var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
      
      switch request {
      case .getTracks(serchText: let serchText):
          print("interactor .getTracks")
          presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
          
          networkService.fetchTracks(searchText: serchText) { [weak self] (searchResponse) in
              self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
          }
          
      }
  }
  
}
