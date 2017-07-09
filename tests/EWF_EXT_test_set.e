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
			new_div.do_nothing

			new_link.set_as_css_file_link ("user1.css")
			last_new_div.add_link_head_item (last_new_link) --> do NOT add until complete because this gets hashed

			new_link.set_as_css_file_link ("user2.css")
			last_new_div.add_link_head_item (last_new_link)

			set_bootstrap_4_package (last_new_div)


			new_link.set_as_css_file_link ("user1.css")
			last_new_div.add_link_body_item (last_new_link)

			new_link.set_as_css_file_link ("user2.css")
			last_new_div.add_link_body_item (last_new_link)


			create l_page.make_with_body ("My Title", "en", "http://www.example.com", last_new_div)
			l_page.prepare_to_send

				assert_strings_equal ("post_prepare_to_send_html_out", post_prepare_to_send_html_out, l_page.html_out)
		end

	default_html: STRING = "[
<!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml">
<body>

</body></html>

]"

	post_prepare_to_send_html_out: STRING = "[
<!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head><title>My Title</title>

<link href="user1.css"  rel="stylesheet"  type="text/css"/>
<link href="user2.css"  rel="stylesheet"  type="text/css"/>
<link crossorigin="anonymous"  href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"  rel="stylesheet"  integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ"/>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"  type="text/javascript"  language="javascript"></script>
<script crossorigin="anonymous"  src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js"  integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb"></script>
<script crossorigin="anonymous"  src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js"  integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn"></script>
</head>
<body>
<!-- body content-->
<div></div>
<!-- body links-->
<link href="user1.css"  rel="stylesheet"  type="text/css"/>
<link href="user2.css"  rel="stylesheet"  type="text/css"/>
<!-- body scripts-->
<!-- body styles-->

</body></html>

]"

feature -- File Scan Tests

	file_scan_tests
			--
		local
			l_cache: EWX_FILE_CACHE
			l_path: PATH
		do
			create l_path.make_empty
			create l_cache
--			l_cache.set_last_file_template (".\files\")
			l_cache.scan_path (create {PATH}.make_from_string ("." + l_path.directory_separator.out + "files" + l_path.directory_separator.out), 0)
		end

end
