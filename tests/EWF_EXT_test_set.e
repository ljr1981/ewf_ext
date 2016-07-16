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

	file_scan_tests
			--
		local
			l_cache: EWX_FILE_CACHE
		do
			create l_cache
			l_cache.scan_path (create {PATH}.make_from_string (".\files\"), 0)
		end

end
