# SwiftyBeaver Website

[![Language Swift 3](https://img.shields.io/badge/Language-Swift%203-orange.svg)](https://swift.org) [![Vapor 1.x](https://img.shields.io/badge/Vapor-1.x-blue.svg)](http://vapor.codes/) [![SwiftyBeaver 1.x](https://img.shields.io/badge/SwiftyBeaver-1.x-blue.svg)] (https://github.com/SwiftyBeaver/SwiftyBeaver) [![Slack Status](https://slack.swiftybeaver.com/badge.svg)](https://slack.swiftybeaver.com) 

Source code of [swiftybeaver.com](https://swiftybeaver.com) powered by server-side Swift 3 with [Vapor](https://github.com/vapor/vapor). <br/><br/>

## Installation

1. Install Xcode 8 
1. Download / clone the repository & go into the project folder
3. Install Vapor: `curl -sL toolbox.vapor.sh | bash`
3. Build the project: `vapor build`
4. Run the web server: `vapor run serve`
5. See the website at [http://0.0.0.0:8080/](http://0.0.0.0:8080/)

<br/>

## Content

### Used Frameworks / Libs:

- [Vapor](https://github.com/vapor/vapor) 1.x
- [Leaf Templating Engine](https://github.com/vapor/leaf)
- [SwiftyBeaver Logging Provider for Vapor](https://github.com/SwiftyBeaver/SwiftyBeaver-Vapor)

### Included Custom Middleware:
- **Cache Control** (set custom cache control header based on file types)
- **CORS** (set cross-origin HTTP request for URL based on file types)
- **Error Page** (WIP: catches & logs HTTP & system errors, renders error pages)

See the [middleware folder](https://github.com/SwiftyBeaver/SBWebsite/tree/master/Sources/SBWebsite/Middleware) for more.
<br/><br/>

## Learn More

- [Website](https://swiftybeaver.com)
- [SwiftyBeaver Framework](https://github.com/SwiftyBeaver/SwiftyBeaver)
- [Documentation](http://docs.swiftybeaver.com/)
- [Medium Blog](https://medium.com/swiftybeaver-blog)
- [On Twitter](https://twitter.com/SwiftyBeaver)


Get support via Github Issues, email and our <b><a href="https://slack.swiftybeaver.com">public Slack channel</a></b>.
<br/><br/>

## License

The Swift source code is released under the [MIT License](https://github.com/SwiftyBeaver/SwiftyBeaver/blob/master/LICENSE). Every other asset (images, videos, SVG files, etc.), is not allowed to be used without permission.
