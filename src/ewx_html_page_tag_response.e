note
	description: "[
		Representation of an effected {EWX_HTML_PAGE_TAG_RESPONSE}.
		]"

class
	EWX_HTML_PAGE_TAG_RESPONSE

inherit
	HTML_PAGE

	WSF_RESPONSE_MESSAGE
		undefine
			default_create,
			out
		end

create
	make_standard,
	make_standard_with_raw_text

feature {NONE} -- Initialization

	make_standard (a_title, a_language_code: STRING; a_widget: HTML_BODY)
			-- `make_standard' with `a_title' and `a_language_code' using `a_widget'.
			-- The `a_widget' will be the first subordinate <tag> beneath <body>.
		local
			l_javascript_files: HASH_TABLE [HTML_SCRIPT, INTEGER]
			l_css_files: HASH_TABLE [HTML_LINK, INTEGER]
			l_scripts: HASH_TABLE [HTML_SCRIPT, INTEGER]
			l_title: HTML_TITLE
		do
			status_code := {HTTP_STATUS_CODE}.ok

			set_xmlns ("http://www.w3.org/1999/xhtml")
			set_lang (a_language_code)
			set_xml_lang (a_language_code)
			set_body (a_widget)

			create l_javascript_files.make (50)
			create l_css_files.make (50)
			create l_scripts.make (50)

				-- Handle all JS file references in <head>
			a_widget.add_head_items (l_javascript_files, l_css_files, l_scripts)

			create internal_head
			create l_title
			l_title.set_text_content (a_title)
			head.add_content (l_title)
			across
				l_javascript_files as ic_js
			loop
				head.add_content (ic_js.item)
			end

				-- Handle all CSS files references in <head>
			across
				l_css_files as ic_css
			loop
				head.add_content (ic_css.item)
			end

				-- Handle all "document ready" scripts in <head>
			across
				l_scripts as ic_scripts
			loop
				head.add_content (ic_scripts.item)
			end
			create header.make_from_raw_header_data (head.html_out)
			header.put_content_type_text_html
		end

	make_standard_with_raw_text (a_title, a_language_code, a_raw_text: STRING)
			-- `make_standard' with `a_title', `a_language_code', and `a_raw_text'.
			-- See `make_standard' for more feature comments.
		local
			l_body: HTML_BODY
		do
			create l_body
			l_body.add_content (create {HTML_TEXT}.make_with_text (a_raw_text))
			make_standard (a_title, a_language_code, l_body)
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
