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
		do
			status_code := {HTTP_STATUS_CODE}.ok

			set_xmlns ("http://www.w3.org/1999/xhtml")
			set_lang (a_language_code)
			set_xml_lang (a_language_code)

			initialize_widget (a_widget)
			body.add_content (a_widget)

			head.add_content (create {HTML_TITLE}.make_with_content (<<create {HTML_TEXT}.make_with_text (a_title)>>))
			build_head (body, head)
			build_body_scripts (a_widget)
			create header.make_from_raw_header_data (head.html_out)
			header.put_content_type_text_html
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
			across l_body_scripts as ic_scripts loop body.add_content (ic_scripts.item) end
		end

	make_standard_with_raw_text (a_title, a_language_code, a_raw_text: STRING)
			-- `make_standard' with `a_title', `a_language_code', and `a_raw_text'.
			-- See `make_standard' for more feature comments.
		local
			l_div: HTML_DIV
		do
			create l_div
			l_div.add_content (create {HTML_TEXT}.make_with_text (a_raw_text))
			make_standard (a_title, a_language_code, l_div)
		end

feature -- Status

	status_code: INTEGER

feature -- Header

	header: HTTP_HEADER

feature {WSF_RESPONSE} -- Output

	send_to (res: WSF_RESPONSE)
			-- <Precursor>
		do
			res.put_string (html_out)
		end

note
	design_intent: "[
		Your_text_goes_here
		]"

end
