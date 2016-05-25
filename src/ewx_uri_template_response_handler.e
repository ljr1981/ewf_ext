note
	description: "[
		Abstraction notion of a {REPLACE_ME}.
		]"

deferred class
	EWX_URI_TEMPLATE_RESPONSE_HANDLER

inherit
	WSF_URI_TEMPLATE_RESPONSE_HANDLER

	SHARED_WSF_PERCENT_ENCODER
		rename
			percent_encoder as url_encoder
		end

note
	design_intent: "[
		Intended as a common request handler.
		]"

end
