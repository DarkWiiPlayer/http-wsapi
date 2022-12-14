# HTTP-WSAPI

A [WSAPI](http://keplerproject.github.io/wsapi) connector for [lua-http](https://github.com/daurnimator/lua-http).

Currently, the conector is dead simple:

```
local wsapi = require 'http.wsapi'
local application = require 'my_wsapi_application'

wsapi.serve(application)
```

This will create a http server and run its `loop` method to serve the given
wsapi application.
