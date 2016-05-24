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

feature {NONE} -- Initialization

	setup_router
			-- <Precursor>
			-- Setup image mapping and caching
		do
				-- Common file requests
			map_uri_template_agent ("/{path_and_file}.js", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.css", agent cache.file_response_handler, get_method_request)

				-- Images and Video
			map_uri_template_agent ("/{path_and_file}.gif", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.png", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.jpg", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.bmp", agent cache.file_response_handler, get_method_request)
			map_uri_template_agent ("/{path_and_file}.mp4", agent cache.file_response_handler, get_method_request)
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
		once ("object")
			create Result.make_from_string ({WSF_REQUEST_METHODS}.method_get)
		end

	Post_method_request: WSF_REQUEST_METHODS
			-- Get_method_request (i.e. "POST")
		once ("object")
			create Result.make_from_string ({WSF_REQUEST_METHODS}.method_post)
		end

	is_common_file_mapping_setup_routed: BOOLEAN
			-- `is_common_file_mapping_setup_routed' ensures `setup_router' has executed.

invariant
	setup_router_executed: is_common_file_mapping_setup_routed

end
