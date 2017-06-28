class
	EWX_HTML_PAGE

inherit
	WSF_HTML_PAGE_RESPONSE
		redefine
			default_create,
			send_to
		end

create
	default_create,
	make_standard,
	make_with_body

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		note
			EIS: "name=doctype_spec", "protocol=URI",
					"src=https://www.w3.org/TR/html5/syntax.html#doctype"
		do
			create_interface_objects
			initialize
			make
		end

	make_standard (a_title: attached like title; a_language: attached like language; a_base: like base)
		do
			default_create
			set_title (a_title)
			set_language (a_language)
			set_base (a_base)
		end

	make_with_body (a_title: attached like title; a_language: attached like language; a_base: like base; a_body: HTML_DIV)
		do
			default_create
			set_title (a_title)
			set_language (a_language)
			set_base (a_base)
			set_body_content (a_body)
		end

	create_interface_objects
		do

		end

	initialize
		do

		end

feature -- Ops

	prepare_to_send
		local
			l_comment: HTML_COMMENT
		do
			if attached body_content as al_body_content then
			-- <!DOCTYPE>
				-- <language>: Handled in `make_with_body'.

			-- <head>
				-- <title>: Handled in `make_with_body'.

				-- <base>
				if attached base as al_base then
					al_body_content.new_base.add_text_content (al_base)
					head_lines.force (al_body_content.last_new_base.html_out)
				end

				-- <meta>
				al_body_content.head_meta_items_refresh
				across
					al_body_content.head_meta_items as ic
				loop
					head_lines.force (ic.item.html_out)
				end

				-- <link>
				al_body_content.head_link_items_refresh
				across
					al_body_content.head_link_items as ic
				loop
					head_lines.force (ic.item.html_out)
				end

				-- <script>
				al_body_content.head_script_items_refresh
				across
					al_body_content.head_script_items as ic
				loop
					head_lines.force (ic.item.html_out)
				end

				-- <style>
				al_body_content.head_style_items_refresh
				across
					al_body_content.head_style_items as ic
				loop
					head_lines.force (ic.item.html_out)
				end

			-- <body> (e.g. <div> item.html_out -> body as STRING)
				create body.make_empty
				if attached body as al_body then
					-- <body> content
					al_body.append ( (create {HTML_COMMENT}.make_with_comment ("body content")).html_out )
					al_body.append_character ('%N')
					al_body.append_string_general (al_body_content.html_out)
					al_body.append_character ('%N')

					-- <link> (i.e. {<link>} items.html_out appended to body as STRING)
					al_body.append ( (create {HTML_COMMENT}.make_with_comment ("body links")).html_out )
					al_body.append_character ('%N')
					al_body_content.body_link_items_refresh
					across
						al_body_content.body_link_items as ic
					loop
						al_body.append_string_general (ic.item.html_out)
						al_body.append_character ('%N')
					end

					-- <script> (i.e. {<script>} items.html_out appended to body as STRING)
					al_body.append ( (create {HTML_COMMENT}.make_with_comment ("body scripts")).html_out )
					al_body.append_character ('%N')
					al_body_content.body_script_items_refresh
					across
						al_body_content.body_script_items as ic
					loop
						al_body.append_string_general (ic.item.html_out)
						al_body.append_character ('%N')
					end

					-- <style> (i.e. {<style>} items.html_out appended to body as STRING)
					al_body.append ( (create {HTML_COMMENT}.make_with_comment ("body styles")).html_out )
					al_body.append_character ('%N')
					al_body_content.body_style_items_refresh
					across
						al_body_content.body_style_items as ic
					loop
						al_body.append_string_general (ic.item.html_out)
						al_body.append_character ('%N')
					end
				end
			end
		end

feature -- Setters: Head

	set_base (s: like base)
		do
			base := s
		end

	set_base_from_args (a_target, a_href: STRING)
		local
			l_base: HTML_BASE
		do
			create l_base
			l_base.set_attribute_manual ("target", a_target, True)
			l_base.set_href (a_href)
			set_base (l_base.html_out)
		end

feature -- Setters: Body

	set_body_content (a_element: like body_content)
		do
			body_content := a_element
		end

feature {WSF_RESPONSE, TEST_SET_BRIDGE} -- Output

	send_to (res: WSF_RESPONSE)
		local
			h: like header
			s: STRING
		do
			s := html_out
			h := header
			res.set_status_code (status_code)

			if not h.has_content_length then
				h.put_content_length (s.count)
			end
			if not h.has_content_type then
				h.put_content_type_text_html
			end
			res.put_header_text (h.string)
			res.put_string (s)
		end

	html_out: STRING
		do
			create Result.make_empty
			Result.append_string_general (doctype_string)
			Result.append_string_general (html_start_tag_string)
			Result.append_string_general (head_string)
			Result.append_string_general (body_string)
			Result.append_string_general (html_end_tag_string)
		end

	last_sent_head: STRING attribute create Result.make_empty end
	last_sent_body: STRING attribute create Result.make_empty end
	last_sent_html: STRING attribute create Result.make_empty end

	doctype_string: STRING
		do
			create Result.make (64)
			if attached doctype as al_doctype then
				Result.append_string_general (al_doctype)
				Result.append_character ('%N')
			end
		end

	html_start_tag_string: STRING
		do
			create Result.make_empty
			Result.append_string_general ("<html xmlns=%"http://www.w3.org/1999/xhtml%"")
			if attached language as lang then
				Result.append_string_general (" xml:lang=%"")
				Result.append_string_general (lang)
				Result.append_string_general ("%" lang=%"")
				Result.append_string_general (lang)
				Result.append_string_general ("%"")
			end
			Result.append_string_general (">%N")
		end

	head_string: STRING
		do
			create last_sent_head.make_empty
			append_html_head_code (last_sent_head)
			Result := last_sent_head
		end

	body_string: STRING
		do
			create last_sent_body.make_empty
			append_html_body_code (last_sent_body)
			Result := last_sent_body
		end

	html_end_tag_string: STRING
		do
			create Result.make_empty
			Result.append_string_general ("</html>%N")
		end

feature {NONE} -- Imp: Access

	base: detachable STRING

	body_content: detachable HTML_DIV

;note
	structure: "[
			<!DOCTYPE html>
			<html>
				<head>
					<title> ... </title>
					<base href="http://www.example.com/news/index.html">
					<link> ... </link>
					<meta> ... </meta>
					<script> ... </script>
					<style> ... </style>
				</head>
				<body>
					<link> ... </link>
					<script> ... </script>
					<style> ... </style>
				</body>
			</html>
		]"
	EIS: "name=head_element", "src=https://www.w3.org/TR/html5/document-metadata.html#the-head-element"
		head_element: "The head element represents a collection of metadata for the Document."

	EIS: "name=title_element", "src=https://www.w3.org/TR/html5/document-metadata.html#the-title-element"
		title_element: "The title element represents the document's title or name."

	EIS: "name=base_element", "src=https://www.w3.org/TR/html5/document-metadata.html#the-base-element"
		base_element: "The base element allows authors to specify the document base URL for the purposes of resolving relative URLs, and the name of the default browsing context for the purposes of following hyperlinks."

	EIS: "name=link_element", "src=https://www.w3.org/TR/html5/document-metadata.html#the-link-element"
		link_element: "The link element allows authors to link their document to other resources."

	EIS: "name=meta_element", "src=src=https://www.w3.org/TR/html5/document-metadata.html#the-meta-element"
		meta_element: "The meta element represents various kinds of metadata that cannot be expressed using the title, base, link, style, and script elements."

	EIS: "name=style_element", "src=https://www.w3.org/TR/html5/document-metadata.html#the-style-element"
		style_element: "The style element allows authors to embed style information in their documents. The style element is one of several inputs to the styling processing model."

	EIS: "name=script_element", "src=https://www.w3.org/TR/html5/scripting-1.html#the-script-element"
		script_element: "The script element allows authors to include dynamic script and data blocks in their documents."



end
