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

feature -- Basic Operations

	file_response_handler (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
			-- `file_response_handler' handles `a_request', sending the file back in `a_response'.
			-- This feature will log failed (not on disk or in cache) as needed.
		note
			design: "[
				All forms of static files (possibly images) (presumed to 
				be files on the file system) are routed here (see setup 
				mapping handlers). The chores are pretty standard:
				
				(1) Turn the request file URI into a string and append
					that to the primary ".\images" folder, where we
					expect to find the requested file (there might be
					others in the future).
					
				(2) Use the `handle_current_path' of {FW_PATH_SCANNER} to
					locate (if there) the precise {PATH} that the file is
					located in.
					
				(3) If found, then create the {WSF_FILE_RESPONSE} with the
					located file path and name as a {STRING} and then send
					that file in the response. Otherwise, log the failure.
				]"
			todo: "[
				(1) Removal of "/images" from the `l_file_string' is a temporary fix.
					This is due to the WC_EDITOR CSS/JS, where the images come in
					with folder prefixes. The mapping templates need to be coded
					to do a better job of managing this. Perhaps sending the image-containing
					maps to another handler, which does the stripping and then hands-off
					to this routine?
				]"
		local
			l_file_response: WSF_FILE_RESPONSE
			l_file_string: STRING
			l_start,
			l_stop: DATE_TIME
		do
			create l_start.make_now
			if
				not a_request.request_uri.has_substring (".mp4") and then
				attached uri_content (a_request.request_uri.out) as al_cached_content
			then
				a_response.send (al_cached_content)
			else
					-- Prep for the next file ...
				last_file_template := Void
				last_file_path := Void
				is_scan_down := False

					-- Get set up
				l_file_string := file_name_in_request (a_request)
				last_file_template := l_file_string

					-- Locate the file (if we can)...
				scan_path (create {PATH}.make_from_string (files_folder_path), 0)

					-- Handle the response
				if attached last_file_path as al_path then
					create l_file_response.make (al_path.name.out + "\" + l_file_string)
					add_uri (a_request.request_uri.out, [l_file_response.twin, context_type_for_request (a_request), True, create {DATE_TIME}.make_now, l_file_response.file_path])
					a_response.send (l_file_response)
				else
				end
			end
			create l_stop.make_now
		end

feature -- Setters

	set_last_file_template (a_last_file_template: like last_file_template)
			-- `set_last_file_template' with `a_last_file_template'
		do
			last_file_template := a_last_file_template
		ensure
			set: last_file_template ~ a_last_file_template
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
			if not l_list.is_empty then
				Result := l_list [l_list.count]
			end
		end

	handle_current_path (a_path: PATH; a_level: INTEGER)
			-- <Precursor>
		do
			check has_template: attached {STRING} last_file_template as al_template then
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
		once ("object")
			Result := current_location.out + backslash.out + files_folder
		end

	files_folder: STRING
			-- `file_folder'.
		once ("object")
			Result := "files"
		end

	forward_slash: CHARACTER = '/'
	backslash: CHARACTER = '\'
	current_location: CHARACTER = '.'

end
