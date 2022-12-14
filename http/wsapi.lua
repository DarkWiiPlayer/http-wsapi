local M = {}

local http_server = require 'http.server'
local http_headers = require 'http.headers'

local function variables(stream)
	local headers = stream:get_headers()
	local result = {}
	local path = headers:get(":path")
	local query do
		local q = path:find("?", 1, false)
		if q then
			query = path:sub(q+1, -1)
			path = path:sub(1, q-1)
		else
			query = ''
		end
	end
	-- RFC 3875 Fields
	result.AUTH_TYPE = ""
	result.CONTENT_LENGTH = headers:get("content-length") or 0
	result.CONTENT_TYPE = headers:get("content-type") or 'application/octet-stream'
	result.GATEWAY_INTERFACE = ""
	result.PATH_INFO = path
	result.PATH_TRANSLATED = ""
	result.QUERY_STRING = query
	result.REMOTE_ADDR = ""
	result.REMOTE_HOST = ""
	result.REMOTE_IDENT = ""
	result.REMOTE_USER = ""
	result.REQUEST_METHOD = headers:get(":method")
	result.SCRIPT_NAME = ""
	result.SERVER_NAME = ""
	result.SERVER_PORT = ""
	result.SERVER_PROTOCOL = ""
	result.SERVER_SOFTWARE = ""
	-- Custom Fields
	result.SCHEME = headers:get(":scheme")
	result.HTTP_ACCEPT = headers:get("accept") or "*"
	-- WSAPI Fields
	result.input = {}
	function result.input.read()
		return stream:get_next_chunk()
	end
	result.error = io.stderr
	return result
end

function M.serve(application)
	local server = http_server.listen {
		host="0.0.0.0",
		port = 8080,
		onstream = function(_, stream)
			local app_status, app_headers, app_body_source = application(variables(stream))

			local headers = http_headers.new()
			headers:append(":status", tostring(app_status))
			for name, value in pairs(app_headers) do
				headers:append(name, value)
			end
			stream:write_headers(headers, false)

			for chunk in app_body_source do
				stream:write_chunk(chunk, false)
			end
			stream:write_chunk("", true)
		end;
		onerror = function(...)
			print(...)
		end
	}

	return server:loop()
end

return M
