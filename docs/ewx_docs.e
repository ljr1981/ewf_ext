note
	description: "[
		Representation of a {EWX_DOCS}
		]"

class
	EWX_DOCS

note
	todo: "[
		(1) The cache needs to be taught if, when, and how to check file resources 
			to see if they have been updated and need to be reloaded and cached 
			again on the next call for the content.
			
			(a) Decide if the cached content needs to be "hot-refreshed" from 
					disk or not.
			(b) If so, how often?
			(c) If so, when? (immediately, on next request access or other?)
			(d) Does this cache refresh mechanism need to be on another thread? 
					(I think yes--this is why I made the ewf_ext library SCOOP'd)
		]"
	design_intent: "[
		The purpose of this library is to provide extended functionality to the
		Eiffel Web Framework (EWF) on a class-by-class basis. We are not looking
		to override functionality, which negates the code here being added to
		some override in Eiffel Studio.
		]"
	http_mime_types: "[
		We have given the HTTP_MIME_TYPEs the capacity to compute a mime type
		based on a given WSF_REQUEST object. This allows us to correctly ID
		content-type on a response to a request.
		]"
	cache_ing: "[
		There is a tremendous need for caching! The first and most obvious item
		to cache are files loaded from a file-system resource (HDD or SSD).
		The PNG file in the EIS below shows you the results of the simple caching
		mechanism when applied (based on the website_x/editor example).
		
		See the TODO items (above) for what plans we presently have to improve
		the caching mechanism.
		
		Caching ought to be extended to also include any request that comes from
		the client, where we do not want to recompute the response, but cache it
		and serve it from the cached version. However, we may need a means by which
		we can "refresh" (e.g. recompute/reload) the cached item on-demand or on
		some use-case/workflow.
		]"
	EIS: "src=$GITHUB\ewf_ext\docs\caching_speed_compare_on_editor_page.png"

end
