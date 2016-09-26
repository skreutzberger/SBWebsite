import Foundation
import Vapor
import HTTP
import SwiftyBeaverVapor
import SwiftyBeaver


// MARK: Providers

// set-up SwiftyBeaver logging destinations (console, file, cloud, ...)
// see http://docs.swiftybeaver.com/category/8-logging-destinations to learn more
// let console = ConsoleDestination()  // log to Xcode Console in color
let file = FileDestination()  // log to file
file.logFileURL = URL(string: "file:///tmp/sbwebsite.log")! // set log file
file.minLevel = .debug // no .verbose logging to file
let sbProvider = SwiftyBeaverProvider(destinations: [file]) // add console to the array if used


// MARK: Middleware

var middleware: [Middleware]? = [
    // set cache control for HTML files to a short TTL and everything else to a long TTL
    CacheControlMiddleware(1800, longTTL: 2592000),
    // allow CORS requests from docs for webfonts and assets
    CorsMiddleware("http://docs.swiftybeaver.com", pathPatterns: ["webfonts", ".png", ".jpg", ".css"]),
    // error pages including 404, WORK IN PROGRESS
    ErrorPageMiddleware("")
]


// MARK: Droplet

let app = Droplet(staticServerMiddleware: middleware, initializedProviders:[sbProvider])
let log = app.log.self // to avoid writing app.log all the time


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

/*
// 404
app.get("*") { request in
    log.warning("called non-existing page \(request.uri)")
    return "the 404 page"
}
*/

app.run()
