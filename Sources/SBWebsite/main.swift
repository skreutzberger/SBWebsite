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
file.logFileURL = URL(fileURLWithPath: "/tmp/sbwebsite.log") // set log file
file.minLevel = .debug // no .verbose logging to file
let sbProvider = SwiftyBeaverProvider(destinations: [console, file])


// MARK: Droplet

// create Droplet & add provider
let app = Droplet()
app.addProvider(sbProvider)

// shortcut to avoid writing app.log all the time
let log = app.log.self


// MARK: Middleware

// use 404.leaf for notFound status and error.leaf for all other errors
// errorPageMiddleware must be added to droplet via availableMiddleware to be called
// after file middleware! That avoids throwing 404 errors for files that are served from Public folder
let errorPageMiddleware = ErrorPageMiddleware("error", errorViews: [Status.notFound: "404"])
// set cache control for .html files to a short TTL and everything else to a long TTL
let cacheControlMiddleware = CacheControlMiddleware(1800, longTTL: 2592000)
// allow cross-origin-resources-requests from docs for webfonts and assets
let corsMiddleWware = CorsMiddleware("http://docs.swiftybeaver.com", pathPatterns: ["webfonts", ".png", ".jpg", ".css"])

// add middlewares to droplet. FileMiddleWare has to come at the end to make 404 pages work
app.middleware.append(cacheControlMiddleware)
app.middleware.append(corsMiddleWware)
app.middleware.append(errorPageMiddleware)
app.middleware.append(FileMiddleware(publicDir: "Public")) // serve static files from Public folder

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
