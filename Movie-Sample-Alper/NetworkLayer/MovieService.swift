//
//  MovieService.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 29.07.2021.
//

import Foundation

enum MovieService: ServiceProtocol {
    
    case list(pageNumber: Int)
    case detail(movieId: Int)
    
    var baseURL: URL {
        return URL(string: NetworkConstants.baseUrl) ?? URL(fileURLWithPath: "")
    }
    
    var path: String {
        switch self {
        case .list(_):
            return  NetworkConstants.movieEndpoint + NetworkConstants.popularEndPoint
        case .detail(let movieId):
            return NetworkConstants.movieEndpoint + "/" + String(movieId)
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .list(let pageNumber):
            let parameters = [NetworkConstants.languageEndPoint: NetworkConstants.englishUs,
                              NetworkConstants.apiKeyEndPoint: NetworkConstants.apiKey,
                              NetworkConstants.pageEndPoint: pageNumber] as [String : Any]
            return .requestParameters(parameters)
        case .detail(_):
            let parameters = [NetworkConstants.languageEndPoint: NetworkConstants.englishUs,
                              NetworkConstants.apiKeyEndPoint: NetworkConstants.apiKey]
            return .requestParameters(parameters)
            
        }
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        return .url
    }
}
