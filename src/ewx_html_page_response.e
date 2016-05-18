note
	description: "[
		Representation of a common {WX_HTML_PAGE_RESPONSE}.
		]"
	design: "[
		See design notes at the end of this class.
		]"

class
	EWX_HTML_PAGE_RESPONSE

inherit
	WSF_HTML_PAGE_RESPONSE

create
	make_standard,
	make_standard_with_raw_text

feature {NONE} -- Initialization

	make_standard (a_title, a_language_code: STRING; a_widget: HTML_TAG)
			-- `make_standard' with `a_title' and `a_language_code' using `a_widget'.
			-- The `a_widget' will be the first subordinate <tag> beneath <body>.
		do
			make
			set_title (a_title)
			set_language (a_language_code)
			set_body (a_widget.html_out)
			add_widget_externals (a_widget)
		ensure
			set_title: attached title as al_title and then al_title.same_string (a_title)
			set_code: attached language as al_language and then al_language.same_string (a_language_code)
		end

	make_standard_with_raw_text (a_title, a_language_code, a_raw_text: STRING)
			-- `make_standard' with `a_title', `a_language_code', and `a_raw_text'.
			-- See `make_standard' for more feature comments.
		do
			make_standard (a_title, a_language_code, create {HTML_TEXT}.make_with_text (a_raw_text))
		end

feature -- Settings

	add_widget_externals (a_widget: HTML_TAG)
			-- `add_widget_externals' for `a_widget' (i.e. external CSS/JS file references).
		do
			across
				a_widget.external_js_files as ic_script
			loop
				head_lines.force (ic_script.item.html_out)
			end
			across
				a_widget.external_css_files as ic_link
			loop
				head_lines.force (ic_link.item.html_out)
			end
		end

note
	design: "[
		The {EWX_HTML_PAGE_RESPONSE} extends the notion of {WSF_HTML_PAGE_RESPONSE}
		by providing convenience creation procedures and supporting routines.
		
		For example: The `make_standard' is designed for "standard" creation of a
		common web page or web-page-based resource, setting the Title, Language, and
		HTML content in a single call (rather than several). It also includes support
		for externally defined JS and CSS files (if required).
		]"

end
