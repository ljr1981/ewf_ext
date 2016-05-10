note
	description: "[
		Abstract notion of an {EWX_CACHE}.
		]"
	design: "[
		An object that can cache things needing to be served quickly,
		but if stale, reloaded (if from an external source) or recomputed.
		]"

class
	EWX_CACHE

feature -- Access

	add_uri (a_uri: attached like uri_anchor; a_uri_data: attached like uri_data_anchor)
			-- `add_uri' `a_uri' with `a_uri_data'.
		do
			cache.force (a_uri_data, a_uri)
		end

feature -- Queries

	uri_content (a_uri: attached like uri_anchor): detachable STRING
			-- Possible `uri_content' for `a_uri'.
		do
			if attached cache.at (a_uri) as al_uri_data then
				Result := al_uri_data.content
			end
		end

feature {NONE} -- Implementation: Access

	cache: HASH_TABLE [attached like uri_data_anchor, attached like uri_anchor]
			-- `cache' of items in Current {EWX_CACHE}.
		note
			design: "[
				The `cache' hash has a collection of `uri_data_anchor' items, keyed
				from `uri_anchor's. This allows the client to look up their URI and
				get back the URI data for that item.
				]"
		attribute
			create Result.make (100)
		end

feature {NONE} -- Implementation: Constants

	uri_anchor: detachable STRING
			-- `uri_anchor'.

	uri_data_anchor: detachable TUPLE [content: STRING; is_stored: BOOLEAN; last_modified: DATE_TIME; location: detachable STRING]
			-- `uri_data_anchor'.

end
