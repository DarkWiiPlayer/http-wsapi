package = "http-wsapi"
version = "dev-1"
source = {
	url = "git+https://github.com/darkwiiplayer/http-wsapi"
}
description = {
	summary = "A WSAPI connector for the lua-http library",
	homepage = "https://github.com/darkwiiplayer/http-wsapi",
	license = "Unlicense",
	labels = { "wsapi", "http", "web" },
}
dependencies = {
	"lua >= 5.1",
	"http ~> 0.4",
	"lumber ~> 2.1",
	"shapeshift ~> 1.1",
	"arrr ~> 2.2",
}
build = {
	type = "builtin",
	modules = {
		["http.wsapi"] = "http/wsapi.lua"
	}
}
