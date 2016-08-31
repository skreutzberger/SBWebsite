//
//  CorsMiddleware.swift
//  SBWebsite
//
//  Created by Sebastian Kreutzberger on 8/31/16.
//  Copyright © 2016 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import Foundation
import Vapor
import HTTP

final class CorsMiddleware: Middleware {
    
    private var origin = ""  // set to * to allow all
    private var pathPatterns = [String]()
    
    /// the given origin domain is allowed to access files 
    /// which contain given path pattern strings
    init(origin: String, pathPatterns: [String]) {
        self.origin = origin
        self.pathPatterns = pathPatterns
    }
    
    /// set CORS headers for certain requested file types
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        
        // get the file extension (suffix) from the requested path
        let response = try chain.respond(to: request)
        let path = request.uri.path
        var setCors = false
        
        for part in pathPatterns {
            // set cors headers if the path contains at least one of the given path patterns
            if path.range(of: part) != nil {
                setCors = true
            }
        }
        
        if setCors {
            print("settings CORS for \(path)")
            response.headers["Access-Control-Allow-Origin"] = origin
            response.headers["Access-Control-Allow-Methods"] = "GET,OPTIONS"
            response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, Content-Length, X-Requested-With"
        }

        return response
    }
    
}
