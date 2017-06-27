note
	description: "Tests of {EWF_EXT}."
	testing: "type/manual"

class
	EWF_EXT_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old,
			clean as test_set_clean
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	HTML_FACTORY
		undefine
			default_create
		end

feature -- Testing: EWX_HTML_PAGE

	ewx_html_page_test
		local
			l_page: EWX_HTML_PAGE
		do
			create l_page
				assert_strings_equal ("default_html", default_html, l_page.html_out)

				-- <head> stuff ...
			new_div.add_link_head_item (new_link)
					last_new_link.set_as_css_file_link ("user1.css")
				last_new_div.add_link_head_item (new_link)
					last_new_link.set_as_css_file_link ("user2.css")
				last_new_div.add_meta_head_item (new_meta)
				last_new_div.add_script_head_item (new_script)
				last_new_div.add_style_head_item (new_style)
					-- <body> stuff ...
				last_new_div.add_link_body_item (new_link)
					last_new_link.set_as_css_file_link ("user1.css")
				last_new_div.add_link_body_item (new_link)
					last_new_link.set_as_css_file_link ("user2.css")
				last_new_div.add_script_body_item (new_script)
				last_new_div.add_style_body_item (new_style)

			create l_page.make_standard ("My Title", "en", "http://www.example.com", last_new_div)
			l_page.prepare_to_send

				assert_strings_equal ("post_prepare_to_send_html_out", post_prepare_to_send_html_out, l_page.html_out)
		end

	default_html: STRING = "[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<body>

</body></html>

]"

	post_prepare_to_send_html_out: STRING = "[
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><title>My Title</title>

<base>http://www.example.com</base>
<meta/>
<link href="user2.css"  rel="stylesheet"  type="text/css"/>
<script></script>
<style></style>
</head>
<body>
<!-- body content-->
<div></div>
<!-- body links-->
<link href="user2.css"  rel="stylesheet"  type="text/css"/>
<!-- body scripts-->
<script></script>
<!-- body styles-->
<style></style>

</body></html>

]"

feature -- Testing: Creation

	ewf_ext_tests
			-- `ewf_ext_tests'
		local
			l_any: EWX_ANY
			l_page: EWX_HTML_PAGE_RESPONSE
			l_cache: EWX_FILE_CACHE
		do
--			create l_any
--			create l_page.make_standard ("title", "en", create {HTML_DIV})
--			create l_cache
		end

	ewx_html_page_tag_response_test
		local
			l_page: EWX_HTML_PAGE_TAG_RESPONSE
		do
--			create l_page.make_standard ("my_title", "en", create {HTML_BODY}.make_with_content (<<create {HTML_TEXT}.make_with_text ("Hello World!")>>))
--			assert_strings_equal ("hello_world_page", hello_world, l_page.html_out)
		end

feature {NONE} -- Page Response Support

	hello_world: STRING = "<!DOCTYPE html><html lang=%"en%"  xml:lang=%"en%"  xmlns=%"http://www.w3.org/1999/xhtml%"><head><title>my_title</title></head><body>Hello World!</body></html>"

feature -- File Scan Tests

	file_scan_tests
			--
		local
			l_cache: EWX_FILE_CACHE
		do
			create l_cache
--			l_cache.set_last_file_template (".\files\")
			l_cache.scan_path (create {PATH}.make_from_string (".\files\"), 0)
		end

end
