note
	description: "[
		Abstract notion of an {EWX_CACHE}.
		]"
	design: "[
		An object that can cache things needing to be served quickly,
		but if stale, reloaded (if from an external source) or recomputed.
		]"

deferred class
	EWX_CACHE

inherit
	EWX_ANY

feature -- Access

	add_uri (a_uri: attached like uri_anchor; a_uri_data: attached like uri_data_anchor)
			-- `add_uri' `a_uri' with `a_uri_data'.
			-- Call this to `add_uri' with `a_uri_data' to the cache. Get it back by calling `uri_content'.
		do
			cache.force (a_uri_data, a_uri.hash_code)
		end

	add_uri_from_path (a_uri: STRING; a_path: PATH)
			-- `add_uri_from_path' for a request `a_uri' and a file `a_path'.
		local
			l_file: RAW_FILE
 			l_extension: STRING
 			l_datetime: DATE_TIME
		do
			create l_file.make_open_read (a_path.absolute_path.name.out)
			l_file.read_stream (l_file.count)
			create l_datetime.make_from_epoch (l_file.change_date)
			add_uri (a_uri, l_file.last_string, a_path.extension, True, l_datetime, a_path)
			if attached a_path.extension as al_ext then
				l_extension := al_ext.out
			else
				create l_extension.make_empty
			end
			l_file.close
		end

feature -- Queries

	uri_content (a_uri: attached like uri_anchor): detachable like uri_data_anchor
			-- Possible `uri_content' for `a_uri'.
			-- Call this to fetch `uri_content' based on some passed `a_uri'.
		do
			if attached cache.at (a_uri.hash_code) as al_uri_data then
				Result := al_uri_data
			end
		end

	uri_content_type (a_uri: attached like uri_anchor): detachable IMMUTABLE_STRING_32
			-- Possible `uri_content_type' for `a_uri'.
			-- Call this to fetch `uri_content' based on some passed `a_uri'.
		do
			if attached cache.at (a_uri.hash_code) as al_uri_data then
				Result := al_uri_data.content_type
			end
		end

	uri_data (a_uri: attached like uri_anchor): like uri_data_anchor
			-- Possible `uri_content_type' for `a_uri'.
			-- Call this to fetch `uri_content' based on some passed `a_uri'.
		do
			if attached cache.at (a_uri.hash_code) as al_uri_data then
				Result := al_uri_data
			end
		end

feature {NONE} -- Implementation: Access

	cache: HASH_TABLE [attached like uri_data_anchor, INTEGER]
			-- `cache' of items in Current {EWX_CACHE}.
		note
			design: "[
				The `cache' hash has a collection of `uri_data_anchor' items, keyed
				from `uri_anchor's hash code. This allows the client to look up their URI and
				get back the URI data for that item.
				]"
		attribute
			create Result.make (100)
		end

feature {NONE} -- Implementation: Constants

	uri_anchor: detachable STRING
			-- `uri_anchor'.

	uri_data_anchor: detachable TUPLE [content: STRING; content_type: detachable IMMUTABLE_STRING_32; is_stored: BOOLEAN; last_modified: DATE_TIME; location: detachable PATH]
			-- `uri_data_anchor'.

end
