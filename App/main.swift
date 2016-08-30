//
//  main.swift
//  SBWebsite, running on https://swiftybeaver.com
//
//  Created by Sebastian Kreutzberger on 8/30/16.
//  Copyright © 2016 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//


import Vapor
//import HTTP

// init the app, ehm drop
let app = Droplet()
// let _ = app.config["app", "key"].string ?? ""

app.get("/") { request in
    return try app.view.make("index", ["title": "App Logging & Analytics Platform for Swift"])
}

app.get("/contact.html") { request in
    return try app.view.make("contact", ["title": "Contact"])
}

app.get("/legal-notice.html") { request in
    return try app.view.make("legal-notice", ["title": "Legal Notice"])
}

/**
    Middleware is a great place to filter
    and modifying incoming requests and outgoing responses.

    Check out the middleware in App/Middleware.

    You can also add middleware to a single route by
    calling the routes inside of `app.middleware(MiddlewareType) {
        app.get() { ... }
    }`
*/
//app.middleware.append(SampleMiddleware())

let port = app.config["app", "port"].int ?? 80

app.serve()
