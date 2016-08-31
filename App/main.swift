//
//  main.swift
//  SBWebsite, running on https://swiftybeaver.com
//
//  Created by Sebastian Kreutzberger on 8/30/16.
//  Copyright © 2016 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//


import Vapor
import HTTP

// init the app, ehm drop
let app = Droplet()
// let _ = app.config["app", "key"].string ?? ""


// MARK: Middlewares

// .html is cached for 30 minutes, assets for 1 month
app.middleware.append(CacheControlMiddleware(shortTTL: 1800, longTTL: 2592000))
// allow CORS requests from docs for webfonts and assets
app.middleware.append(CorsMiddleware(origin: "http://docs.swiftybeaver.com", pathPatterns: ["webfonts", ".png", ".jpg", ".css"]))


// MARK: Routes

app.get("/") { request in
    return try app.view.make("index", ["title": "App Logging & Analytics Platform for Swift"])
}

app.get("/contact.html") { request in
    return try app.view.make("contact", ["title": "Contact"])
}

app.get("/legal-notice.html") { request in
    return try app.view.make("legal-notice", ["title": "Legal Notice"])
}


// MARK: Server

let port = app.config["app", "port"].int ?? 80
app.serve()
