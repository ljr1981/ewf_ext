class
	EWX_HEAD_BUILDER

inherit
	EWX_ANY

feature {NONE} -- Initialization

	build_head (a_widget: HTML_TAG; a_head: HTML_HEAD)
			-- Build the <head> ... </head> content.
		local
			l_javascript_files: HASH_TABLE [HTML_SCRIPT, INTEGER]
			l_css_files: HASH_TABLE [HTML_LINK, INTEGER]
			l_scripts: HASH_TABLE [HTML_SCRIPT, INTEGER]
		do
--			create l_javascript_files.make (50)
--			create l_css_files.make (50)
--			create l_scripts.make (50)

--				-- Handle all JS file references in <head>
--			a_widget.add_head_items (l_javascript_files, l_css_files, l_scripts)

--			across
--				l_javascript_files as ic_js
--			loop
--				a_head.add_content (ic_js.item)
--			end

--				-- Handle all CSS files references in <head>
--			across
--				l_css_files as ic_css
--			loop
--				a_head.add_content (ic_css.item)
--			end

--				-- Handle all "document ready" scripts in <head>
--			across
--				l_scripts as ic_scripts
--			loop
--				a_head.add_content (ic_scripts.item)
--			end
			is_head_built := True
		end

	is_head_built: BOOLEAN

end
