note
	description: "[
		Representation of a {APP_EXECUTION}.
		]"
	design: "[
		See notes at the end of this class.
		]"

class
	APP_EXECUTION

inherit
	WSF_ROUTED_EXECUTION

	WSF_ROUTED_URI_HELPER

	WSF_ROUTED_URI_TEMPLATE_HELPER

create
	make

feature {NONE} -- Initialization

	setup_router
			-- Map `uri_hello' request (by template) to `hello_request_handler' agent with `no_request_methods'.
		note
			design: "[
				{WSF_ROUTED_EXECUTION}
				{WSF_ROUTED_URI_HELPER}
				{WSF_ROUTED_URI_TEMPLATE_HELPER}
				
				Each of the classes (above) have features which handle various forms of routing
				based on message templates (e.g. `uri_hello')
				]"
		do
			map_uri_agent (uri_hello, agent hello_request_handler (?, ?), no_request_methods)
		end

feature -- Execution

	hello_request_handler (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
			-- Send `l_html_page_response' through `a_response' message based on `a_request'.
		note
			design: "[
				This routine is designed to specifically handle a Client request such as:
				
				http://localhost:9999/hello
				
				It is a single static HTML page sent back to the Client as a response.
				
				The basic steps followed are:
				
				(1) Create the response object (e.g. `l_html_page_response').
				(2) Call any "settings" (e.g. Optional and Required).
				(3) Send the response page back to the Client through the HTTPD Web Server.
				
				Therefore, once this ECF-template is in-place, you may compile and
				run this application (either in Work-bench mode or Finalized). When you
				do, then move to your browser and navigate to: http://localhost:9999/hello
				This will demonstrate this as a working template. You may then redesign
				and code out your own Web Server as you like, need, and want.
				]"
		local
			l_html_page_response: WSF_HTML_PAGE_RESPONSE
		do
			create l_html_page_response.make

				-- Optional settings
			l_html_page_response.set_title ("Hello Eiffel Web World")
			l_html_page_response.set_language ("en")

				-- Required (loads CSS and page body)
			l_html_page_response.head_lines.force (hello_world_css)
			l_html_page_response.set_body (hello_world_body)

			a_response.send (l_html_page_response)
		end

feature {NONE} -- Implementation: Constants

	uri_hello: STRING = "/hello"
			-- `uri_hello' router template map.

	hello_world_body: STRING = "[
<div class="block__element">
	Hello Eiffel Web World!
</div>
<div class="main__paragraph">
	<p class="column__right">
		This is the first paragraph to display. It will be followed by a standard Lorem Ipsum.
	</p>
	<p class="column__left">
		Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut tincidunt elit nec 
		imperdiet dignissim. Cras vehicula nec dolor non ultrices. Nam porta, metus in 
		tincidunt sagittis, enim turpis rutrum diam, vitae malesuada orci sem id metus. 
		Nulla ut purus et odio molestie aliquet. Mauris bibendum turpis vitae augue 
		vehicula, ac ullamcorper lectus pulvinar. Sed ornare sapien eu purus lacinia 
		efficitur. Duis quis lobortis nibh, id vulputate tortor. Duis at eros at libero 
		sollicitudin aliquam ut non ipsum. Vestibulum sit amet pharetra metus. Nunc 
		massa velit, placerat vel tellus a, gravida egestas purus. Nulla facilisi.
	</p>
	<p class="column__right">
		Pellentesque habitant morbi tristique senectus et netus et malesuada fames 
		ac turpis egestas. Nam quis ex sed erat lacinia semper et ac justo. Vivamus 
		iaculis bibendum arcu nec efficitur. Etiam dapibus felis eget rhoncus sagittis. 
		Nulla facilisi. Aliquam erat volutpat. Pellentesque hendrerit et urna eget 
		ullamcorper.
	</p>
	<p class="column__left">
		Maecenas lobortis, ante quis porta vulputate, quam libero volutpat augue, 
		quis ornare erat nunc sit amet ante. Mauris vitae rhoncus turpis. Aliquam 
		erat volutpat. Praesent interdum dui et justo auctor feugiat. Donec quis 
		ultricies mauris, at imperdiet neque. Suspendisse ut lorem diam. Morbi sapien 
		mi, accumsan nec metus in, sodales tempus dui. Fusce in lobortis elit, 
		volutpat accumsan urna. Nulla scelerisque, est ut laoreet feugiat, tellus 
		ipsum elementum ante, eget dictum tellus nisi id neque. Nam eu sem at urna 
		blandit molestie. Nulla eu vestibulum ipsum. Nullam feugiat nunc eget elit 
		maximus lobortis. Integer at dapibus magna. Nulla pellentesque lacus eu 
		condimentum malesuada. Mauris quis efficitur quam. Suspendisse potenti.
	</p>
	<p class="column__right">
		Proin ut neque enim. Proin posuere viverra nunc. Nam vel facilisis sem. Sed 
		elementum dui condimentum, aliquam ante at, laoreet arcu. Praesent nec magna 
		accumsan, volutpat nisi et, blandit ex. Class aptent taciti sociosqu ad litora 
		torquent per conubia nostra, per inceptos himenaeos. Nulla nibh lorem, iaculis 
		in dolor eu, varius finibus ex. Sed scelerisque finibus diam non consectetur. 
		Morbi convallis vehicula dui non gravida. Donec placerat vitae purus suscipit 
		auctor. Aenean sapien lorem, blandit vitae ullamcorper vitae, ultrices 
		ullamcorper mauris.
	</p>
	<p class="column__left">
		Praesent vitae pellentesque metus. Aliquam rutrum elementum cursus. Nullam 
		sed tempor turpis, vel fringilla orci. In pharetra velit sapien, eu sollicitudin 
		arcu varius ac. Sed turpis justo, venenatis eu volutpat quis, laoreet finibus 
		est. Sed vulputate porta est vitae facilisis. Vestibulum vitae sem nisi. 
		Curabitur non hendrerit tortor. Praesent in lacus bibendum, pretium augue 
		nec, commodo velit.
	</p>
</div>
]"

	hello_world_css: STRING = "[
<style>
	.block__element {
		color: blue; 
		background-color: yellow;
		font-size: 30px;
		font-family: "Lucida Console";
		float: right;
		}
	.column__left {
		float: left;
		}
	.column__right {
		float: right;
		}
</style>
]"

	no_request_methods: detachable WSF_REQUEST_METHODS
			-- `no_request_methods' constant.
		once
			Result := Void
		end

note
	design: "[
		{APP_EXECUTION} is just a template (starting point) to build from. You may
		design your application any way you like or want. However, the basics are
		fairly well established: Each instance of a Web Service has a Router, which
		uses URI templates to route incoming Client requests through the Web Server
		to an appropriate "message handler".
		
		The message handler may be any class you create. They do not have to be in
		this class, although something like this class is required for each HTTPD
		Web Server service object (see {APPLICATION}). Handlers are always features
		on a class (object) that receive some form of request and then parse the
		request, deciding which handler feature will process the request, compute the
		response, and then send that response back to the Client (if a response is
		even needed--sometimes, no reponse is required).
		
		Note that this is the place to design-build-and-test a RESTful architecture.
		]"

end
