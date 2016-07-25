note
	description: "Tests of {EWF_EXT}."
	testing: "type/manual"

class
	EWF_EXT_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Testing: Creation

	ewf_ext_tests
			-- `ewf_ext_tests'
		local
			l_any: EWX_ANY
			l_page: EWX_HTML_PAGE_RESPONSE
			l_cache: EWX_FILE_CACHE
		do
			create l_any
			create l_page.make_standard ("title", "en", create {HTML_DIV})
			create l_cache
		end

	ewx_html_page_tag_response_test
		local
			l_page: EWX_HTML_PAGE_TAG_RESPONSE
		do
			create l_page.make_standard ("my_title", "en", create {HTML_BODY}.make_with_content (<<create {HTML_TEXT}.make_with_text ("Hello World!")>>))
			assert_strings_equal ("hello_world_page", hello_world, l_page.html_out)
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
			l_cache.set_last_file_template (".\files\")
			l_cache.scan_path (create {PATH}.make_from_string (".\files\"), 0)
		end

end
