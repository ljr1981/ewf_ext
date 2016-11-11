note
	description: "[
		Representation of an {EWX_FILE_CACHE}.
		]"

class
	EWX_FILE_CACHE

inherit
	EWX_CACHE

	FW_PATH_SCANNER
		export {TEST_SET_BRIDGE}
			scan_path,
			is_scan_down
		end

	EWX_HTTP_MIME_TYPES
		export {NONE}
			all
		end

	EWX_COMPRESSION_ENABLED

feature -- Basic Operations

	file_response_handler (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
			-- `file_response_handler' handles `a_request', sending the file back in `a_response'.
		local
			l_meta: HTML_META
			l_file: RAW_FILE
 			l_extension: STRING
 			l_datetime: DATE_TIME
		do
			if
				not a_request.request_uri.has_substring (".mp4") and then
				attached uri_content (a_request.request_uri.out) as al_cached_file_response
			then
				send_uri_content (a_request, a_response, al_cached_file_response)
			else
				if attached scan (create {PATH}.make_from_string (files_folder_path), file_name_in_request (a_request)) as al_path then
					add_uri_from_path (a_request.request_uri.out, al_path)
					check has_uri_content: attached uri_content (a_request.request_uri.out) as al_cached_file_response then
						send_uri_content (a_request, a_response, al_cached_file_response)
					end
				else
					a_response.send (create {WSF_NOT_FOUND_RESPONSE}.make (a_request))
				end
			end
		end

	send_uri_content (a_request: WSF_REQUEST; a_response: WSF_RESPONSE; a_uri_content: attached like uri_data_anchor)
		local
			l_extension: STRING
		do
			if attached a_uri_content.content_type as al_ext then
				l_extension := al_ext.out
			else
				create l_extension.make_empty
			end
			send_computed_get_response (a_request, a_response, a_uri_content.content, l_extension, a_uri_content.last_modified)
		end

feature {NONE} -- Implementation: File location services

	file_name_in_request (a_request: WSF_REQUEST): STRING
			-- `file_name_in_request' `a_request'.
		note
			semantic: "[
				This feature takes in a request, which may be a call with
				back/forward-slashed heirarchy, such as: images/my_image.png
				]"
			design_intent: "[
				The entire design of the caching system for files is that
				one can place a file anywhere in a file structure and the
				code can locate it.
				
				To ensure we are looking only for file resource names, we need
				to strip any pathing information from the request. This feature
				performs that job.
				]"
			warning: "[
				The caveat is that the file names must be unique because the
				system will find the first file matching the request and return
				it. If the name of the file resource is not unique, then there
				remains the possibility that the first file found may not be
				the correct file. Thus, the incumbancy on the file resource
				provider/maintainer to ensure uniqueness of file resource names!
				]"
			todo: "[
				(1) Ensure uniqueness of named file resources! This may be another
				part of the system or it may be something like the Eiffel Studio
				UUID mechanism. The system may need to understand that files are
				not located in a single directly, but in one or more. If so, then
				there will need to be a design discussion around this. For the moment,
				we can place all files in a single directly named "files" and then
				ensure unique file names in that structure.
				]"
		local
			l_list: LIST [STRING]
		do
			create Result.make_empty
			l_list := a_request.request_uri.out.split (forward_slash)
			check has_list: not l_list.is_empty then
				Result := l_list [l_list.count]
			end
		end

	handle_current_path (a_path: PATH; a_level: INTEGER)
			-- <Precursor>
		do
			if attached {STRING} last_file_template as al_template then
				if (create {DIRECTORY}.make_with_path (a_path)).has_entry (al_template) then
					last_file_path := a_path
				end
			end
			is_scan_down := not attached last_file_path
		end

	last_file_template: detachable STRING
			-- The `last_file_template' {STRING} used to locate `last_file_path'.

	last_file_path: detachable PATH
			-- The `last_file_path' used by Clients like `file_response_handler' (possibly more).

feature {NONE} -- Implementation: Constants

	files_folder_path: STRING
		local
			l_env: EXECUTION_ENVIRONMENT
		once ("object")
			Result := current_location + backslash.out + files_folder
		end

	files_folder: STRING
			-- `file_folder'.
		once ("object")
			Result := "files"
		end

	forward_slash: CHARACTER = '/'
	backslash: CHARACTER = '\'
	current_location: STRING
		local
			l_env: EXECUTION_ENVIRONMENT
		once
			create l_env
			Result := l_env.current_working_path.absolute_path.name.out
		end

end
