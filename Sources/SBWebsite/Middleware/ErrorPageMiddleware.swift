//
//  ErrorPageMiddleware
//  SBWebsite
//
//  Created by Sebastian Kreutzberger on 9/20/16.
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import HTTP
import Vapor

/**
 Handles the various Abort errors that can be thrown
 in any Vapor closure.
 
 Renders a template associated with a given status code
 */
public class ErrorPageMiddleware: Middleware {
    
    /// needs to be added after the middleware was added to the droplet
    public var droplet = Droplet()

    private var defaultErrorView = ""
    private var errorViews = [Status: String]() // name of error view template
    
    /// accepts a default error view and optionally a dict of views per status
    public init(_ defaultErrorView: String , errorViews: [Status: String]=[Status: String]()) {
        self.defaultErrorView = defaultErrorView
            self.errorViews = errorViews
    }
    
    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch Abort.badRequest {
            return try errorResponse(request, status: .badRequest, message: "Invalid request")
        } catch Abort.notFound {
            return try errorResponse(request, status: .notFound, message: "Page not found")
        } catch Abort.serverError {
            return try errorResponse(request, status: .internalServerError, message: "Something went wrong")
        } catch Abort.custom(let status, let message) {
            return try errorResponse(request, status: status, message: message)
        }
    }
    
    /// renders the view for the error status or default view if not set
    func errorResponse(_ request: Request, status: Status, message: String) throws -> Response {
       
        // render default view template or a specific one for the error
        var viewName = defaultErrorView
        
        if let view = errorViews[status] {
            viewName = view
        }
        
        // log errors with error level and 404 with info level
        if status == .notFound {
            log.info("\(message): \(request.uri.path)")
        } else {
            log.error("\(status): \(request.uri.path) - \(message)")
        }
        
        let renderedView = try droplet.view.make(viewName, ["title": Node(message)])
        let data = try renderedView.makeBytes()
        let response = Response(status: status, body: .data(data))
        response.headers["Content-Type"] = "text/html; charset=utf-8"
        
        return response
    }
    
}

