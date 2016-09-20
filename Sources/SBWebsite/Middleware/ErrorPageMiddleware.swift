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
 Handles the various Abort rrors that can be thrown
 in any Vapor closure.
 
 To stop this behavior, remove the
 ErrorMiddleware for the Droplet's `middleware` array.
 */
public class ErrorPageMiddleware: Middleware {
    
    private var errorView = "" // name of error view template
    
    public init(_ errorView: String) {
        self.errorView = errorView
    }
    
    /**
     Respond to a given request chaining to the next
     
     - parameter request: request to process
     - parameter chain: next responder to pass request to
     
     - throws: an error on failure
     
     - returns: a valid response
     */
    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch Abort.badRequest {
            return try ErrorPageMiddleware.errorResponse(request, .badRequest, "Invalid request")
        } catch Abort.notFound {
            return try ErrorPageMiddleware.errorResponse(request, .notFound, "Page not found")
        } catch Abort.serverError {
            return try ErrorPageMiddleware.errorResponse(request, .internalServerError, "Something went wrong")
        } catch Abort.custom(let status, let message) {
            return try ErrorPageMiddleware.errorResponse(request, status, message)
        }
    }
    
    static func errorResponse(_ request: Request, _ status: Status, _ message: String) throws -> Response {
        
        // log the error
        log.error("\(status): \(message)")
        
        if request.accept.prefers("html") {
            // TODO: how to render error view template here??
            
            //return ErrorView.shared.makeResponse(status, message)
            //return Response(status: status, body: "")
            //return try app.view.make("contact", ["title": message])
        }
        
        let json = try JSON(node: [
            "error": true,
            "message": "\(message)"
            ])
        let data = try json.makeBytes()
        let response = Response(status: status, body: .data(data))
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response
    }
    
}

