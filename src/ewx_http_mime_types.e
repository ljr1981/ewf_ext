note
	description: "[
		Representation of {EWX_HTTP_MIME_TYPES}.
		]"

class
	EWX_HTTP_MIME_TYPES

inherit
	HTTP_MIME_TYPES

feature -- Queries

	context_type_for_request (a_request: WSF_REQUEST): detachable STRING
			-- `context_type_for_request' `a_request'.
		note
			todo: "[
				(1) Extend this feature to cover the remaining MIME types
					and match them to their various forms of `a_request'.
				]"
		local
			l_ext: STRING
			l_list: LIST [STRING]
		do
			l_list := a_request.request_uri.out.split ('.')
			if l_list.count >= 2 then
				l_ext := l_list [l_list.count]
				if l_ext.same_string ("bmp") then
					Result := image_bmp
				elseif l_ext.same_string ("gif") then
					Result := image_gif
				elseif l_ext.same_string ("jpeg") then
					Result := image_jpeg
				elseif l_ext.same_string ("jpg") then
					Result := image_jpg
				elseif l_ext.same_string ("png") then
					Result := image_png
				elseif l_ext.same_string ("svg") or l_ext.same_string ("xml") then
					Result := image_svg_xml
				elseif l_ext.same_string ("tiff") then
					Result := image_tiff
				elseif l_ext.same_string ("ico") then
					Result := image_x_ico

					-- Application types
				elseif l_ext.same_string ("js") then
					Result := application_javascript

					-- Text types
				elseif l_ext.same_string ("css") then
					Result := text_css

					-- Unknown
				else
					check unknown_content_type: False end
				end
			end
		end

end
