note
	description: "[
		Representation of an effected {EWX_HTML_PAGE_TAG_RESPONSE}.
		]"

deferred class
	EWX_HTML_PAGE_TAG_RESPONSE

inherit
	HTML_PAGE
		rename
			documentation as html_documentation
		redefine
			make_standard
		end

	WSF_RESPONSE_MESSAGE
		undefine
			default_create,
			out
		end

feature {NONE} -- Initialization

	make_standard (a_title, a_language_code: STRING; a_widget: HTML_DIV)
			-- <Precursor>
		do
			status_code := {HTTP_STATUS_CODE}.ok

			Precursor (a_title, a_language_code, a_widget)

			--build_head (body, head)
			create header.make_from_raw_header_data (head.html_out)
			header.put_content_type_text_html
		end

feature -- Basic Ops

	meta_expiry_date_string: STRING
			-- `meta_expiry_date_string' is the well-formed expiration date for meta head tags.
		local
			l_date: DATE
		do
			create l_date.make_now
			inspect
				l_date.day_of_the_week
			when 1 then
				Result := "sun, "
			when 2 then
				Result := "mon, "
			when 3 then
				Result := "tue, "
			when 4 then
				Result := "wed, "
			when 5 then
				Result := "thu, "
			when 6 then
				Result := "fri, "
			when 7 then
				Result := "sat, "
			end
			if l_date.day < 10 then
				Result.append_string_general ("0" + l_date.day.out)
			else
				Result.append_string_general (l_date.day.out)
			end
			inspect
				l_date.month
			when 1 then
				Result.append_string_general (" jan")
			when 2 then
				Result.append_string_general (" feb")
			when 3 then
				Result.append_string_general (" mar")
			when 4 then
				Result.append_string_general (" apr")
			when 5 then
				Result.append_string_general (" may")
			when 6 then
				Result.append_string_general (" jun")
			when 7 then
				Result.append_string_general (" jul")
			when 8 then
				Result.append_string_general (" aug")
			when 9 then
				Result.append_string_general (" sep")
			when 10 then
				Result.append_string_general (" oct")
			when 11 then
				Result.append_string_general (" nov")
			when 12 then
				Result.append_string_general (" dec")
			end
			Result.append_string_general (" " + l_date.year.out)
		end

feature -- Status

	status_code: INTEGER

feature -- Header

	header: HTTP_HEADER

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
			-- <Precursor>
		local
			l_html: READABLE_STRING_8
		do
			l_html := html_out
			res.header.put_content_length (l_html.count)
			res.header.put_content_type_text_html
			res.put_string (html_out)
		end

note
	design_intent: "[
		Your_text_goes_here
		]"

end
