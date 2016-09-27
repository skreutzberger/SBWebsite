import Foundation
import Vapor
import HTTP
import SwiftyBeaverVapor
import SwiftyBeaver


// MARK: Providers

// set-up SwiftyBeaver logging destinations (console, file, cloud, ...)
// see http://docs.swiftybeaver.com/category/8-logging-destinations to learn more
let console = ConsoleDestination()  // log to Xcode Console in color
let file = FileDestination()  // log to file
file.logFileURL = URL(string: "file:///tmp/sbwebsite.log")! // set log file
file.minLevel = .debug // no .verbose logging to file
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])


// MARK: Middleware

// use 404.leaf for notFound status and error.leaf for all other errors
// errorPageMiddleware must be added to droplet via availableMiddleware to be called
// after file middleware! That avoids throwing 404 errors for files that are served from Public folder
var errorPageMiddleware = ErrorPageMiddleware("error", errorViews: [Status.notFound: "404"])

var middleware: [String: Middleware]? = [
    // set cache control for HTML files to a short TTL and everything else to a long TTL
    "cache-control": CacheControlMiddleware(1800, longTTL: 2592000),
    // allow CORS requests from docs for webfonts and assets
    "cors": CorsMiddleware("http://docs.swiftybeaver.com", pathPatterns: ["webfonts", ".png", ".jpg", ".css"]),
    // serve error pages
    "error-page": errorPageMiddleware,
    // WIP: remove key Server from response header to hide Vapor as server
    //"incognito": IncognitoMiddleware()
    
]

// MARK: Droplet

let app = Droplet(availableMiddleware: middleware, initializedProviders:[sbProvider])
let log = app.log.self // to avoid writing app.log all the time
errorPageMiddleware.droplet = app // required for error view rendering


// MARK: Routes

// home route
app.get("/") { request in
    return try app.view.make("index", ["title": "App Logging & Analytics Platform for Swift"])
}


app.get("/contact.html") { request in
    return try app.view.make("contact", ["title": "Contact"])
}

app.get("/legal-notice.html") { request in
    return try app.view.make("legal-notice", ["title": "Legal Notice"])
}


app.run()
