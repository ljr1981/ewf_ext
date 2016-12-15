class
	EWX_COMPRESSION_ENABLED

feature {NONE} -- Basic Ops

	send_arbitrary_file_get_response (a_request: WSF_REQUEST; a_response: WSF_RESPONSE; a_file_path: STRING)
		local
			l_file: RAW_FILE
			l_path: PATH
			l_ext: STRING
		do
			create l_path.make_from_string (a_file_path)
			create l_file.make_open_read (l_path.absolute_path.name.out)
			l_file.read_stream (l_file.count)
			if attached l_path.extension as al_ext then
				l_ext := al_ext.out
			else
				create l_ext.make_empty
			end
			send_computed_get_response (a_request, a_response, l_file.last_string, l_ext, create {DATE_TIME}.make_from_epoch (l_file.change_date))
		end

 	send_computed_get_response (a_request: WSF_REQUEST; a_response: WSF_RESPONSE; a_message, a_content_type: STRING; a_datetime: DATE_TIME)
 			-- `send_computed_get_response' to `a_request' as `a_response' with `a_message'.
 		local
 			l_http_header: HTTP_HEADER
 			l_http_date: HTTP_DATE
 			l_message: STRING
 		do
 				-- Prepare a header (in preparation for compression settings)
 			create l_http_header.make
 			if a_content_type.same_string ("css") then
 				l_http_header.put_content_type_text_css
 			elseif a_content_type.same_string ("js") then
 				l_http_header.put_content_type_text_javascript
 			elseif a_content_type.same_string ("csv") then
 				l_http_header.put_content_type_text_csv
 			elseif a_content_type.same_string ("json") then
 				l_http_header.put_content_type_text_json
 			elseif a_content_type.same_string ("html") then
 				l_http_header.put_content_type_text_html
 			elseif a_content_type.same_string ("application/javascript") then
 				l_http_header.put_content_type_application_javascript
 			elseif a_content_type.same_string ("application/json") then
 				l_http_header.put_content_type_application_json
 			elseif a_content_type.same_string ("application/pdf") then
 				l_http_header.put_content_type_application_pdf
 			elseif a_content_type.same_string ("zip") then
 				l_http_header.put_content_type_application_zip
 			else
 				l_http_header.put_content_type_text_plain
 			end

				-- Compress data if requested.
 			if attached generated_compressed_output (a_request, l_http_header, a_message) as al_compressed_content then
 				l_message := al_compressed_content
 			else
 				create l_message.make_from_string (a_message)
 			end

				-- Depending on compression results, set header data
 			l_http_header.put_content_length (l_message.count)
 			l_http_header.put_last_modified (a_datetime)
 			l_http_header.put_cache_control ("max-age=120")
 			l_http_header.put_raw_header_data ("ETag:" + ('"').out + a_message.hash_code.out + ('"').out)
 			if attached a_request.request_time as al_time then
 				create l_http_date.make_from_date_time (al_time)
 				l_http_header.add_header ("Date:" + l_http_date.rfc1123_string)
 			end

 				-- Final forming and sending of response
 			a_response.set_status_code ({HTTP_STATUS_CODE}.ok)
 			a_response.put_header_text (l_http_header.string)
 			a_response.put_string (l_message)
 		end

	generated_compressed_output (a_request: WSF_REQUEST; a_http_header: HTTP_HEADER; a_message: STRING): detachable STRING
			-- If `a_request' supports compression and the server supports one of our deflation algorithms,
			-- compress `a_message' and update `a_http_header' with "Content-Encoding:deflate".
		do
			if is_compression_supported then
				 -- As part of an HTTP Client request, we need to check if the Header contains accept-encoding
				 --	and if our server support it.

	 			 -- For example:
	 			 -- Accept-Encoding: gzip, deflate

	 				-- Check the CLIENT request
	 			if
	 				attached a_request.http_accept_encoding as al_encoding_specification and then
	 					al_encoding_specification.has_substring ("deflate")
	 			then
	 				-- If the client supports compression and one of the algorithms is `deflate' we can do compression.
	 				-- Also, we need to add the corresponding 'Content-Ecoding' with the supported deflate algorithm.
	 				Result := do_compress (a_message)
	 				a_http_header.add_header ("Content-Encoding:deflate")
	 			end
	 		end
 		end

 	do_compress (a_string: STRING): STRING
 			-- Compress `a_string' using `deflate'
			-- We use the default compression level.
		local
			l_string_compressor: ZLIB_STRING_COMPRESS
		do
			create Result.make_empty
			create l_string_compressor.string_stream (Result) --.string_stream_with_size (Result, deflation_chunk_size)
			l_string_compressor.put_string (a_string)
--			l_string_compressor.put_string_with_options (a_string, {ZLIB_CONSTANTS}.Z_default_compression,
--															default_compression_level,
--															default_memory_level,
--															{ZLIB_CONSTANTS}.z_default_strategy.to_integer_32)
		end

feature {NONE} -- Implementation: Constants

	is_compression_supported: BOOLEAN = True -- Based on Javier's SHARED_COMPRESSION class, but we do not require a class for this.

	deflation_chunk_size: INTEGER = 32_768
			 -- `deflation_chunk_size' is roughly 32k.

	default_compression_level: INTEGER = 15
			-- We use the default value for windows bits, the range is (8 |..| 15).
			--	Higher values use more memory, but produce smaller output.

	default_memory_level: INTEGER = 9
			-- Memory: Higher values use more memory, but are faster and produce smaller output.
			--	The default is 8, we use 9.

end
