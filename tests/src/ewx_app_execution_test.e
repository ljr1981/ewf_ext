note
	description: "[
		Representation of a {EWX_APP_EXECUTION_TEST}.
		]"
	overview: "[
		This class has a single web page (see `hello_request_handler'), which
		uses an example of an {EWX_HTML_PAGE} class using CDN-based Boostrap 4
		to form itself as a Sample Blog page.
		
		The page consists of several components:
		(1) Navbar
		(2) Blog Header
		(3) Blogs #1, #2, and #3
		(4) Blog sidebar
		(5) One <link> and three <script> items in the <head> for CDN external references
		(6) Blog CSS injected as an internal <style>
		]"
	design: "[
		See notes at the end of this class.
		]"

class
	EWX_APP_EXECUTION_TEST

inherit
	EWX_APP_EXECUTION
		redefine
			setup_router
		end

	HTML_FACTORY
		undefine
			default_create
		end

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
			Precursor
			map_uri_agent (uri_hello, agent hello_request_handler (?, ?), no_request_methods)
			map_uri_agent ("/datatable", agent datatable_handler (?, ?), no_request_methods)
		end

feature -- Execution

	datatable_handler (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
		local
			l_page: EWX_DATA_TABLES_EXAMPLE
		do
			create l_page.make_standard ("Data Table", "en", "")
			l_page.prepare_to_send
			a_response.send (l_page)
		end

	hello_request_handler (a_request: WSF_REQUEST; a_response: WSF_RESPONSE)
			-- Send `l_html_page_response' through `a_response' message based on `a_request'.
		note
			EIS: "src=http://localhost:9999/hello"
		local
			l_page: EWX_HTML_PAGE
			l_div,
			l_div_column,
			l_div_row: HTML_DIV
			l_content: STRING
		do
			create l_div
					-- <head> materials ...
				set_bootstrap_4_package (l_div)

					-- <body> content ...
				create l_div_column
					l_div_column.set_class_names ("container")
				create l_div_row
					l_div_row.set_class_names ("row")
				l_div_column.add_content (l_div_row)
					create l_content.make_empty
					l_content.append_string_general (blog_main (<<blog_post_1, blog_post_2, blog_post_3>>).html_out)
					l_content.append_character ('%N')
					l_content.append_string_general (blog_side_bar (blog_archives).html_out)
					l_div_row.add_text_content (l_content)

				l_div.add_content (navbar)
				l_div.add_content (blog_header)
				l_div.add_content (l_div_column)

				new_style.set_text_content (blog_css)
				l_div.add_style_body_item (last_new_style)

			create l_page.make_with_body ("My Test Page", "en", "", l_div)
			l_page.prepare_to_send
			a_response.send (l_page)
		end

feature {NONE} -- Implementation: Constants

	uri_hello: STRING = "/hello"
			-- `uri_hello' router template map.

feature {NONE} -- Components

	navbar: HTML_DIV
		local
			l_div2: HTML_DIV
		do
			create Result
			Result.set_class_names ("blog-masthead")
				create l_div2
				l_div2.set_class_names ("container")
				Result.add_content (l_div2)
					l_div2.add_content (new_nav)
						last_new_nav.set_class_names ("nav blog-nav")
						last_new_nav.add_content (new_a)
							last_new_a.set_class_names ("nav-link active")
							last_new_a.set_href ("#")
							last_new_a.set_text_content ("Home")
						last_new_nav.add_content (new_a)
							last_new_a.set_class_names ("nav-link")
							last_new_a.set_href ("#")
							last_new_a.set_text_content ("New features")
						last_new_nav.add_content (new_a)
							last_new_a.set_class_names ("nav-link")
							last_new_a.set_href ("#")
							last_new_a.set_text_content ("Press")
						last_new_nav.add_content (new_a)
							last_new_a.set_class_names ("nav-link")
							last_new_a.set_href ("#")
							last_new_a.set_text_content ("New hires")
						last_new_nav.add_content (new_a)
							last_new_a.set_class_names ("nav-link")
							last_new_a.set_href ("#")
							last_new_a.set_text_content ("About")
		end

	blog_header: HTML_DIV
		local
			l_div2: HTML_DIV
		do
			create Result
			Result.set_class_names ("blog-header")
				create l_div2
				l_div2.set_class_names ("container")
				Result.add_content (l_div2)
					l_div2.add_content (new_h1)
						last_new_h1.set_class_names ("blog-title")
						last_new_h1.set_text_content ("The Bootstrap Blog")
					l_div2.add_content (new_p)
						last_new_p.set_class_names ("lead blog-description")
						last_new_p.set_text_content ("An example blog template built with Bootstrap.")

		end

	blog_css: STRING = "[
/*
 * Globals
 */

@media (min-width: 48em) {
  html {
    font-size: 18px;
  }
}

body {
  font-family: Georgia, "Times New Roman", Times, serif;
  color: #555;
}

h1, .h1,
h2, .h2,
h3, .h3,
h4, .h4,
h5, .h5,
h6, .h6 {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-weight: normal;
  color: #333;
}


/*
 * Override Bootstrap's default container.
 */

.container {
  max-width: 60rem;
}


/*
 * Masthead for nav
 */

.blog-masthead {
  margin-bottom: 3rem;
  background-color: #428bca;
  -webkit-box-shadow: inset 0 -.1rem .25rem rgba(0,0,0,.1);
          box-shadow: inset 0 -.1rem .25rem rgba(0,0,0,.1);
}

/* Nav links */
.nav-link {
  position: relative;
  padding: 1rem;
  font-weight: 500;
  color: #cdddeb;
}
.nav-link:hover,
.nav-link:focus {
  color: #fff;
  background-color: transparent;
}

/* Active state gets a caret at the bottom */
.nav-link.active {
  color: #fff;
}
.nav-link.active:after {
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 0;
  height: 0;
  margin-left: -.3rem;
  vertical-align: middle;
  content: "";
  border-right: .3rem solid transparent;
  border-bottom: .3rem solid;
  border-left: .3rem solid transparent;
}


/*
 * Blog name and description
 */

.blog-header {
  padding-bottom: 1.25rem;
  margin-bottom: 2rem;
  border-bottom: .05rem solid #eee;
}
.blog-title {
  margin-bottom: 0;
  font-size: 2rem;
  font-weight: normal;
}
.blog-description {
  font-size: 1.1rem;
  color: #999;
}

@media (min-width: 40em) {
  .blog-title {
    font-size: 3.5rem;
  }
}


/*
 * Main column and sidebar layout
 */

/* Sidebar modules for boxing content */
.sidebar-module {
  padding: 1rem;
  /*margin: 0 -1rem 1rem;*/
}
.sidebar-module-inset {
  padding: 1rem;
  background-color: #f5f5f5;
  border-radius: .25rem;
}
.sidebar-module-inset p:last-child,
.sidebar-module-inset ul:last-child,
.sidebar-module-inset ol:last-child {
  margin-bottom: 0;
}


/* Pagination */
.blog-pagination {
  margin-bottom: 4rem;
}
.blog-pagination > .btn {
  border-radius: 2rem;
}


/*
 * Blog posts
 */

.blog-post {
  margin-bottom: 4rem;
}
.blog-post-title {
  margin-bottom: .25rem;
  font-size: 2.5rem;
}
.blog-post-meta {
  margin-bottom: 1.25rem;
  color: #999;
}


/*
 * Footer
 */

.blog-footer {
  padding: 2.5rem 0;
  color: #999;
  text-align: center;
  background-color: #f9f9f9;
  border-top: .05rem solid #e5e5e5;
}
.blog-footer p:last-child {
  margin-bottom: 0;
}
]"

feature {NONE} -- Blog Posts

	blog_post_1: HTML_DIV do Result := blog_post ("Sample blog post", "January 1, 2014", "#", "Mark", blog_post_1_string) end
	blog_post_2: HTML_DIV do Result := blog_post ("Another blog post", "December 23, 2013", "#", "Jacob", blog_post_2_string) end
	blog_post_3: HTML_DIV do Result := blog_post ("New feature", "December 14, 2013", "#", "Chris", blog_post_3_string) end

feature {NONE} -- Blog Ops

	blog_main (a_posts: ARRAY [HTML_DIV]): HTML_DIV
		do
			create Result
				Result.set_class_names ("col-sm-8 blog-main")
			across
				a_posts as ic
			loop
				Result.add_content (ic.item)
			end
		end

	blog_post (a_title, a_date, a_author_href, a_author, a_content: STRING): HTML_DIV
		do
			create Result
			Result.add_content (blog_post_title (a_title))
			Result.add_content (blog_post_title_meta (a_date, a_author_href, a_author))
			Result.add_text_content (a_content)
		end

	blog_post_title (a_title: STRING): HTML_H2
		do
			Result := new_h2
				last_new_h2.set_class_names ("blog-post-title")
				last_new_h2.add_text_content (a_title)
		end

	blog_post_title_meta (a_date, a_href, a_author: STRING): HTML_P
		do
			Result := new_p
				last_new_p.set_class_names ("blog-post-meta")
				new_text_content.append_string_general (a_date)
				last_new_text_content.append_string_general (" by ")
				new_a.set_href (a_href)
				last_new_a.add_text_content (a_author)
				last_new_text_content.append_string_general (last_new_a.html_out)
				Result.add_text_content (last_new_text_content)
		end

feature {NONE} -- Blog Contents

	blog_post_1_string: STRING = "[
            <p>This blog post shows a few different types of content that's supported and styled with Bootstrap. Basic typography, images, and code are all supported.</p>
            <hr>
            <p>Cum sociis natoque penatibus et magnis <a href="#">dis parturient montes</a>, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.</p>
            <blockquote>
              <p>Curabitur blandit tempus porttitor. <strong>Nullam quis risus eget urna mollis</strong> ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
            </blockquote>
            <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
            <h2>Heading</h2>
            <p>Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.</p>
            <h3>Sub-heading</h3>
            <p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</p>
            <pre><code>Example code block</code></pre>
            <p>Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa.</p>
            <h3>Sub-heading</h3>
            <p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
            <ul>
              <li>Praesent commodo cursus magna, vel scelerisque nisl consectetur et.</li>
              <li>Donec id elit non mi porta gravida at eget metus.</li>
              <li>Nulla vitae elit libero, a pharetra augue.</li>
            </ul>
            <p>Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue.</p>
            <ol>
              <li>Vestibulum id ligula porta felis euismod semper.</li>
              <li>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.</li>
              <li>Maecenas sed diam eget risus varius blandit sit amet non magna.</li>
            </ol>
            <p>Cras mattis consectetur purus sit amet fermentum. Sed posuere consectetur est at lobortis.</p>
]"

	blog_post_2_string: STRING = "[
            <p>Cum sociis natoque penatibus et magnis <a href="#">dis parturient montes</a>, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.</p>
            <blockquote>
              <p>Curabitur blandit tempus porttitor. <strong>Nullam quis risus eget urna mollis</strong> ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
            </blockquote>
            <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
            <p>Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.</p>
]"

	blog_post_3_string: STRING = "[
            <p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
            <ul>
              <li>Praesent commodo cursus magna, vel scelerisque nisl consectetur et.</li>
              <li>Donec id elit non mi porta gravida at eget metus.</li>
              <li>Nulla vitae elit libero, a pharetra augue.</li>
            </ul>
            <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
            <p>Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue.</p>
]"

feature {NONE} -- Blog Sidebar

	blog_archives: ARRAY [TUPLE [href, mmyyyy: STRING]]
		do
			Result := <<
						["#","March 2014"],
						["#","February 2014"],
						["#","January 2014"],
						["#","December 2013"],
						["#","November 2013"],
						["#","October 2013"],
						["#","September 2013"],
						["#","August 2013"],
						["#","July 2013"],
						["#","June 2013"],
						["#","May 2013"],
						["#","April 2013"]
						>>
		end

	blog_side_bar (a_items: ARRAY [TUPLE [href, mmyyyy: STRING]]): HTML_DIV
		local
			l_div1,
			l_div2,
			l_div3: HTML_DIV
		do
			create Result
				Result.set_class_names ("col-sm-3 offset-sm-1 blog-sidebar")
				create l_div1
				Result.add_content (l_div1)
					l_div1.set_class_names ("sidebar-module sidebar-module-inset")
					l_div1.add_content (new_h4)
						last_new_h4.add_text_content ("About")
					l_div1.add_content (new_p)
						last_new_p.set_text_content ("Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.")
				create l_div2
				Result.add_content (l_div2)
					l_div2.set_class_names ("sidebar-module")
					l_div2.add_content (new_h4)
						last_new_h4.set_text_content ("Archives")
					l_div2.add_content (new_ol)
						last_new_ol.set_class_names ("list-unstyled")
--						last_new_ol.add_content (new_li)
--							last_new_li.add_content (new_a)
--								last_new
						across
							a_items as ic
						loop
							last_new_ol.add_content (new_li)
								last_new_li.add_content (new_a)
									last_new_a.set_href (ic.item.href)
									last_new_a.set_text_content (ic.item.mmyyyy)
						end
				create l_div3
				Result.add_content (l_div3)
					l_div3.set_class_names ("sidebar-module")
					l_div3.add_content (new_h4)
						last_new_h4.set_text_content ("Elsewhere")
					l_div3.add_content (new_ol)
						last_new_ol.add_content (new_li)
							last_new_li.add_content (new_a)
								last_new_a.set_href ("#")
								last_new_a.set_text_content ("GitHub")
						last_new_ol.add_content (new_li)
							last_new_li.add_content (new_a)
								last_new_a.set_href ("#")
								last_new_a.set_text_content ("Twitter")
						last_new_ol.add_content (new_li)
							last_new_li.add_content (new_a)
								last_new_a.set_href ("#")
								last_new_a.set_text_content ("Facebook")
		end

;note
	design: "[
		{EWX_APP_EXECUTION} is just a template (starting point) to build from. You may
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
