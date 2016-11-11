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
		end

	WSF_RESPONSE_MESSAGE
		undefine
			default_create,
			out
		end

	EWX_HEAD_BUILDER
		undefine
			default_create,
			out
		end

feature {NONE} -- Initialization

	make_standard (a_title, a_language_code: STRING; a_widget: HTML_DIV)
			-- `make_standard' with `a_title' and `a_language_code' using `a_widget'.
			-- The `a_widget' will be the first subordinate <tag> beneath <body>.
		note
			EIS: "name=cache_control_max_age",
					"src=https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching#cache-control"
		local
			l_css_link: HTML_LINK
			l_javascript: HTML_SCRIPT
		do
			status_code := {HTTP_STATUS_CODE}.ok

			set_xmlns ("http://www.w3.org/1999/xhtml")
			set_lang (a_language_code)
			set_xml_lang (a_language_code)

			initialize_widget (a_widget)
			body.extend (a_widget)

			head.add_content (create {HTML_TITLE}.make_with_content (<<create {HTML_TEXT}.make_with_text (a_title)>>))

				-- Viewport
			head.extend (new_meta)
			last_new_meta.set_name ("viewport")
			last_new_meta.set_content ("width=device-width, initial-scale=1")

			build_head (body, head)
			create header.make_from_raw_header_data (head.html_out)
			header.put_content_type_text_html

			across
				manually_specified_css_files as ic
			loop
				create l_css_link.make_as_css_file_link (ic.item)
				body.extend (l_css_link)
			end

			across
				manually_specified_javascript_files as ic
			loop
				create l_javascript.make_with_javascript_file_name (ic.item)
				body.extend (l_javascript)
			end
			build_body_scripts (a_widget)
			build_body_styles (a_widget)
		end

	initialize_widget (a_widget: HTML_TAG)
			-- `initialize_widget' `a_widget' by adding content.
		deferred
		end

	build_body_scripts (a_widget: HTML_TAG)
			-- `build_body_scripts', which are <script> elements extracted from `a_widget' tree.
		local
			l_body_scripts: ARRAYED_LIST [HTML_SCRIPT]
		do
			create l_body_scripts.make (10)
			a_widget.add_body_scripts (l_body_scripts)
			across l_body_scripts as ic_scripts loop body.extend (ic_scripts.item) end
		end

	build_body_styles (a_widget: HTML_TAG)
			-- `build_body_styles', which are <style> elements extracted from `a_widget' tree.
		local
			l_head_styles: ARRAYED_LIST [HTML_STYLE]
		do
			create l_head_styles.make (10)
			a_widget.add_head_styles (l_head_styles)
			across l_head_styles as ic_styles loop head.extend (ic_styles.item) end
		end

	make_standard_with_raw_text (a_title, a_language_code, a_raw_text: STRING)
			-- `make_standard' with `a_title', `a_language_code', and `a_raw_text'.
			-- See `make_standard' for more feature comments.
		local
			l_div: HTML_DIV
		do
			create l_div
			l_div.extend (create {HTML_TEXT}.make_with_text (a_raw_text))
			make_standard (a_title, a_language_code, l_div)
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
