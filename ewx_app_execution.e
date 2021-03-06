note
	description: "[
		Abstract notion of a {EWX_APP_EXECUTION}.
		]"

deferred class
	EWX_APP_EXECUTION

inherit
	WSF_ROUTED_EXECUTION
		redefine
			setup_router
		end

	WSF_ROUTED_URI_HELPER

	WSF_ROUTED_URI_TEMPLATE_HELPER

	EWX_COMPRESSION_ENABLED

feature {NONE} -- Initialization

	setup_router
			-- <Precursor>
			-- Setup image mapping and caching
		note
			EIS: "name=X-Frame-Options_001", "src=https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options"
			EIS: "name=HTTP_charset_parameter_002", "src=https://www.w3.org/International/articles/http-charset/index"
		do
			response.header.add_header_key_value ("X-Frame-Options", "SAMEORIGIN") -- See EIS X-Frame-Options_001
			response.header.add_header_key_value ("Content-Type", "text/html; charset=utf-8")-- See EIS HTTP_charset_parameter_002

				-- Common file requests
			map_uri_template_agent ("/{path_and_file}.ico", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.js", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.css", agent cache.file_response_handler, get_method_request)

			map_uri_template_agent ("/{path_and_file}.ICO", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.JS", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.CSS", agent cache.file_response_handler, get_method_request)

				-- Images and Video
			map_uri_template_agent ("/{path_and_file}.gif", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.png", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.jpg", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.jpeg", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.bmp", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.mp4", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.svg", agent cache.file_response_handler, get_method_request)

			map_uri_template_agent ("/{path_and_file}.GIF", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.PNG", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.JPG", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.JPEG", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.BMP", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.MP4", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.SVG", agent cache.file_response_handler, get_method_request)

			is_common_file_mapping_setup_routed := True
		end

	cache: EWX_FILE_CACHE
			-- `cache' of file(s) content.
		once
			create Result
		end

feature {NONE} -- Implementation: Constants

	no_request_methods: detachable WSF_REQUEST_METHODS
			-- `no_request_methods' constant.
		once
			Result := Void
		end

	get_method_request: WSF_REQUEST_METHODS
			-- `get_method_request' (i.e. "GET")
		once
			create Result.make_from_string ({WSF_REQUEST_METHODS}.method_get)
		end

	Post_method_request: WSF_REQUEST_METHODS
			-- Get_method_request (i.e. "POST")
		once
			create Result.make_from_string ({WSF_REQUEST_METHODS}.method_post)
		end

	is_common_file_mapping_setup_routed: BOOLEAN
			-- `is_common_file_mapping_setup_routed' ensures `setup_router' has executed.

invariant
	setup_router_executed: is_common_file_mapping_setup_routed

end
