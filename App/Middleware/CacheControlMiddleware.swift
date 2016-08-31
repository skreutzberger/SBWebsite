//
//  CacheControlMiddleware.swift
//  SBWebsite
//
//  Created by Sebastian Kreutzberger on 8/31/16.
//  Copyright © 2016 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation
import Vapor
import HTTP

final class CacheControlMiddleware: Middleware {
    
    // adjust the Cache-Control header for certain requested file types
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        
        // get the file extension (suffix) from the requested path
        let response = try chain.respond(to: request)
        let path = request.uri.path
        var suffix = ""
        if let fileName = path.components(separatedBy: "/").last {
            let parts = fileName.components(separatedBy: ".")
            suffix = parts.last!
        }
        
        var cacheTTL = 0
        
        if suffix == "" || suffix == "html" {
            cacheTTL = 1800  // 30 min cache
        } else {
            // all remaining are long-cached
            cacheTTL = 2592000  // 1 month
        }

        print("setting cache-control for \(path) to \(cacheTTL) seconds")
        response.headers["Cache-Control"] = "public, max-age=\(cacheTTL)"
        response.headers["Vary"] = "Accept-Encoding"
        
        return response
    }

}
