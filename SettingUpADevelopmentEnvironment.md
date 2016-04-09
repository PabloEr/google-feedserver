<h1>Setting Up a Development Environment</h1>

The purpose of this document is to provide information on creating a development environment and to help with builds, source code controls, and code reviews.

The sections that follow explain how to set up a development environment for modifying and building the Feed Server open source code.

---

<h2>Contents</h2>


---

# Requirements #
To build code and run it, ensure that you have the following environment setup:
  * Java 1.6
  * Ant 1.6.5 or higher--if you are using an Ant version prior to 1.7.0, copy `junit.jar` into the `${ANT_HOME}/lib` directory.
    * http://ant.apache.org/bindownload.cgi
  * Jetty is included and is the default servlet engine
  * Abdera is included as a library
    * Currently Abdera 1.0 snapshot build (built on Jan 29 2008) is included. This will be updated later with newer snapshot build till we have the Abdera 1.0 public release

Optional:
  * Apache Tomcat 6
    * http://tomcat.apache.org/download-60.cgi

---

# Before Starting #

Before starting, read the
[Apache Abdera Getting Started documentation](http://cwiki.apache.org/ABDERA/getting-started.html).  You can read the Overview document for high level goals of a project.

Jetty is bundled with the Google Feed Server and provides build targets for a Tomcat WAR file.  You can implement the server as needed.


---

# Checking Out Source Code #

To check out source code, you need to obtain a Subversion client such as Tortoise. For more information, see http://www.tigris.org.
Use the following command to check out the source code:

`svn checkout https://google-feedserver.googlecode.com/svn/trunk/ google-feedserver --username <<yourUserName>>`

---

# Building with Ant #
The Ant script builds the codebase and runs the Feed Server with either Jetty or Tomcat as the servlet container.

## Building for Jetty ##
At the root of the source tree, execute the `ant` command, which builds the `dist/feedserver.jar` JAR file.

## Building for Tomcat ##
Create a `build.properties` file that indicates your Tomcat directory (the root directory of your Tomcat installation).  For example:
```
    catalina.home=/opt/tomcat
    url.manager=http://localhost:8080/manager
    manager.username=admin
    manager.password=admin
```

Do not add this file to the source code repository--this file exists only in your local configuration.
Add the administative user to Tomcat's `tomcat-users.xml` users file.
```
    <role rolename="manager"/>
    <user username="admin" password="admin" roles="manager"/>
```

Start Tomcat and verify that it is accepting connections. You can ensure that Tomcat is working with the http://127.0.0.1:8080 URL. If the Tomcat start page appears, then Tomcat is active. The Tomcat server needs to be running when executing the following command:

At the root of the source tree, execute the `ant tomcat` command, which builds `feedserver.war` and deploys the WAR file to the `${catalina.home}/webapps` folder.

---

# Running Google Feed Server #
The sections that follow explain how to run the Feed Server.

## Database Configuration ##
[Apache Derby](http://db.apache.org/derby/) is bundled as the default database to work with samples.
<ol>
<li>The database configuration parameters need to be updated in the following file: <code>conf/database/dbConfig.properties</code>.  Edit the connection URL, driver name, user name, password, and other parameters to point to your specific database.</li>
<li>The SQL script is located under <code>conf/database/sql/{database}/create-contact-table.sql</code>.  Specify the path of this file in the <code>dbConfig.properties</code> file in the <code>sqlFilePath</code>.</li>
<li>The database can be created by running the <code>ant target: createDb</code> command.<br>
<p>In case you are using Derby (default), the database is created in the same directory where you run the Ant script.</p>
<p>If you are deploying on Tomcat with Derby, ensure that you make the following entry in <code>%CATALINA_HOME%/conf/catalina.properties</code>:</p>
<p><code>derby.system.home=</code>{absolute path to the directory where the derby database has been created}</p>
<p>For example, set the default project directory to <code>/home/GoogleFeedServer</code>.<br>
The <code>createDb</code> command creates the <code>feedserver</code> database in this directory entry in:</p><p><code>%CATALINA_HOME%/conf/catalina.properties:derby.system.home=/home/GoogleFeedServer</code></p></li>
<li>Based on the database server being used, modify the query that will get the newly generated iID from the database for a new feed entry. The ID will be part of the <code>contact-insert-entry</code> node in <code>conf/feedserver/sqlmap/contact.xml</code></li>
</ol>

## Running the Feed Server with Jetty ##

To run the Feed Server with the Jetty container, run the following script: `run.sh`

You can try the sample feed to check that output is being generated. The feed pulls the feed entires with the default data populated in the database.

`$ curl localhost:8080/example.com/contact | tidy -xml -indent -quiet`

## Running the Feed Server with Tomcat ##

After you've built and deployed, you should have a `feedserver.war` file in your Tomcat `webapps` folder. You can use the Tomcat manager to verify that the WAR files has been installed.

Test the following URL in your browser: <br><a href='http://127.0.0.1:8080/feedserver/example.com/contact'>http://127.0.0.1:8080/feedserver/example.com/contact</a> and check the output.<br>
<br>
<hr />
<h1>Working with Authenticated Requests</h1>
The Feed server by default does not handle signed requests.<br>
<br>
You can configure the Feed Server to handle signed requests:<br>
# Google ClientLogin<br>
# OAuth<br>
The sections that follow describe each configuration.<br>
<br>
<h2>Using Google Client Login</h2>

The following sections describe the use of Google ClientLogin.<br>
<br>
<h3>For Jetty</h3>

To enable authenticated requests, run the <code>run.sh authenticated=true</code> command.<br>
<br>
This command accepts requests that have been signed with Google ClientLogin authentication and authorization mechanism.<br>
<br>
<h3>For Tomcat</h3>

Before building the code base, uncomment the following lines in the <code>web/WEB-INF/web.xml</code> file to enable the servlet to grant authorization tokens and  to enable a filter that validates the authorization token that is embedded in each request:<br>
<pre><code><br>
&lt;!-- The filter to intercept each request and check for the authorization token --&gt;<br>
<br>
&lt;filter&gt;<br>
     &lt;filter-name&gt;SignedRequestFilter&lt;/filter-name&gt;<br>
    &lt;filter-class&gt;com.google.feedserver.filters.SignedRequestFilter&lt;/filter-class&gt;<br>
&lt;/filter&gt;<br>
<br>
&lt;filter-mapping&gt;<br>
     &lt;filter-name&gt;SignedRequestFilter&lt;/filter-name&gt;<br>
     &lt;url-pattern&gt;/*&lt;/url-pattern&gt;<br>
&lt;/filter-mapping&gt;<br>
<br>
<br>
&lt;!--The servlet that generates tokens --&gt;<br>
<br>
&lt;servlet id="auth-servlet"&gt;<br>
    &lt;servlet-name&gt;GetAuthTokenServlet&lt;/servlet-name&gt;<br>
    &lt;servlet-class&gt;com.google.feedserver.server.servlet.GetAuthTokenServlet&lt;/servlet-class&gt;<br>
  &lt;/servlet&gt;<br>
<br>
  &lt;servlet-mapping id="auth-servlet-mapping"&gt;<br>
    &lt;servlet-name&gt;GetAuthTokenServlet&lt;/servlet-name&gt;<br>
    &lt;url-pattern&gt;/accounts/ClientLogin&lt;/url-pattern&gt;<br>
  &lt;/servlet-mapping&gt;<br>
<br>
<br>
  &lt;!-- The GUICE listener creates an injector for the TokenManager instance required by the SignedRequestFilter &amp; GetAuthTokenServlet --&gt;<br>
<br>
  &lt;listener&gt;<br>
    &lt;listener-class&gt;com.google.feedserver.server.servlet.GuiceServletContextListener&lt;/listener-class&gt;<br>
  &lt;/listener&gt;<br>
<br>
</code></pre>

Build and deploy the WAR file for Tomcat, use the <code>ant tomcat</code> command.<br>
<br>
<br>
<hr />
<h1>Using the Feed Server Client Tool</h1>

To test signed requests, you can use a the <code>FeedServerClientTool</code> using the following scripts in the <code>resources/clientTool</code> folder:<br>
<ul><li><code>setupEnv.sh</code> -- Set up the parameter values required by all other scripts<br>
</li><li><code>getFeed.sh</code> -- The script to retrieve a feed<br>
</li><li><code>getEntry.sh</code> -- The script to retrieve a particular entry<br>
</li><li><code>insertEntry.sh</code> -- To add a new entry to the feed<br>
</li><li><code>updateEntry.sh</code> -- Update an existing entry<br>
</li><li><code>deleteEntry.sh</code> -- Delete an existing entry</li></ul>

You can download a pre-built version of the <a href='http://google-feedserver.googlecode.com/files/client-tools.zip'>FSCT client tools</a> from the Downloads tab.<br>
<br>
Before running these shell scripts, create the client JAR file (if not using the pre-built FSCT client tools). Run the <code>ant client</code> Ant target.<br>
<br>
When running each  script, you are prompted for a password. The username should be set in <code>setupEnv.sh (or setupEnv.bat)</code>. For the sample feeds, you can use any username and password as no authentication is done to validate the user. In a production environment, configure the Feed Server to authenticate users for the service and issue tokens to authorize requests.<br>
<br>
<h2>Details of Each Script</h2>

<h3>setupEnv.sh</h3>

Update the <code>setupEnv.sh</code> script with a domain name for the feeds and the other parameters required for authentication and authorization:<br>
<ul><li>FSCT_DOMAIN -- Domain name<br>
</li><li>FSCT_USER_NAME -- The username<br>
</li><li>FSCT_FEED_BASE -- The feed URL<br>
</li><li>SERVICE_NAME -- The name of the service with which the user account is associated. For the sample feeds, it is <code>test</code>.<br>
</li><li>AUTHN_URL_PROTOCOL -- Name of the protocol to use for authentication, either <code>http</code> or <code>https</code>.<br>
</li><li>AUTHN_URL -- The end point that handles authentication and grants authorization tokens to be used with each request.<br>
<i>Note: If the Feed Server is running on Tomcat, ensure that you include the correct application root in the FSCT_FEED_BASE and AUTHN_URL</i> parameters.</li></ul>

<h3>getFeed.sh</h3>

The <code>getFeed.sh</code> script fetchs the feed and all the entries that belong to this feed.<br>
Run this script as follows:<br>
<pre><code>$&gt; ./getFeed.sh &lt;&lt;feed_name&gt;&gt;<br>
</code></pre>
For example: <code>./getFeed.sh contact</code>
The output appears as:<br>
<pre><code>&lt;entities&gt;<br>
  &lt;entity&gt;<br>
    &lt;id&gt;http://localhost:8080/example.com/contact/1&lt;/id&gt;<br>
    &lt;lastName&gt;Simon&lt;/lastName&gt;<br>
    &lt;email&gt;jsimon@example.com&lt;/email&gt;<br>
    &lt;rating&gt;5&lt;/rating&gt;<br>
    &lt;firstName&gt;Jim&lt;/firstName&gt;<br>
  &lt;/entity&gt;<br>
  &lt;entity&gt;<br>
    &lt;id&gt;http://localhost:8080/example.com/contact/2&lt;/id&gt;<br>
    &lt;lastName&gt;Doe&lt;/lastName&gt;<br>
    &lt;email&gt;jdoe@example.com&lt;/email&gt;<br>
    &lt;rating&gt;10&lt;/rating&gt;<br>
    &lt;firstName&gt;John&lt;/firstName&gt;<br>
  &lt;/entity&gt;<br>
&lt;/entities&gt;<br>
</code></pre>

<h3>getEntry.sh</h3>

The <code>getEntry.sh</code> script fetchs a specific entry for a feed<br>
Run this script as follows:<br>
<pre><code>$&gt; ./getEntry.sh &lt;&lt;feed_name&gt;&gt; &lt;&lt;entry_id&gt;&gt;<br>
</code></pre>
For example: <code>/getEntry.sh contact 1</code>
The output appears as:<br>
<pre><code>&lt;entity&gt;<br>
  &lt;id&gt;http://localhost:8080/example.com/contact/1&lt;/id&gt;<br>
  &lt;lastName&gt;Simon&lt;/lastName&gt;<br>
  &lt;email&gt;jsimon@example.com&lt;/email&gt;<br>
  &lt;rating&gt;5&lt;/rating&gt;<br>
  &lt;firstName&gt;Jim&lt;/firstName&gt;<br>
&lt;/entity&gt;<br>
</code></pre>

<h3>insertEntry.sh</h3>

The <code>insertEntry.sh</code> script adds a new entry to a feed. The feed entry details come from a file whose path is specified as input in the script : -<code>entryFilePath &lt;path to the file&gt;</code>
Run this script as follows:<br>
<br>
<code>$&gt; insertEntry.sh &lt;&lt;feed_name&gt;&gt;</code>
For example:  <code>$&gt; insertEntry.sh contact</code>
The newly added feed entry appears as output:<br>
<pre><code>&lt;entity&gt;<br>
  &lt;id&gt;http://localhost:8080/example.com/contact/3&lt;/id&gt;<br>
  &lt;lastName&gt;Moore&lt;/lastName&gt;<br>
  &lt;email&gt;jmoore@example.com&lt;/email&gt;<br>
  &lt;rating&gt;8&lt;/rating&gt;<br>
  &lt;firstName&gt;Jimmy&lt;/firstName&gt;<br>
&lt;/entity&gt;<br>
</code></pre>

<h3>updateEntry.sh</h3>

The <code>updateEntry.sh</code> script updates an existing feed entry. The feed entry details should come from a file whose path is specified as input in the script : <code>-entryFilePath &lt;path to the file&gt;</code>}.<br>
Run this script as follows:<br>
<br>
<code>$&gt; updateEntry.sh &lt;&lt;feed_name&gt;&gt; &lt;&lt;entry_id&gt;&gt;</code>
For example: <code>updateEntry.sh contact 2</code>

<b>Note:</b> The ID of the feed entry in the file and the input must be same.<br>
The updated feed entry appears as output:<br>
<pre><code>&lt;entity&gt;<br>
  &lt;id&gt;http://localhost:8080/example.com/contact/2&lt;/id&gt;<br>
  &lt;lastName&gt;Doe&lt;/lastName&gt;<br>
  &lt;email&gt;johndoe@example.com&lt;/email&gt;<br>
  &lt;rating&gt;22&lt;/rating&gt;<br>
  &lt;firstName&gt;John&lt;/firstName&gt;<br>
&lt;/entity&gt;<br>
</code></pre>

<h3>deleteEntry.sh</h3>

The <code>deleteEntry.sh</code> script deletes an existing feed entry.<br>
Run this script as follows:<br>
<code>$&gt; deleteEntry.sh &lt;&lt;feed_name&gt;&gt; &lt;&lt;entry_id&gt;&gt;</code>
For example: <code>deleteEntry.sh contact 2</code>


<h2>Using OAuth</h2>
The code base ships with a filter that intercepts each request and checks requests for those signed with OAuth.<br>
<br>
<h3>OAuth With Jetty</h3>

To enable OAuth signed requests, run the script with the following command line arguments: <code>run.sh OAuth_authenticated=true</code>. This<br>
command accepts requests signed with the OAuth authentication and authorization mechanism. The default consumer key is the Google public key.<br>
<br>
<h3>OAuth With Tomcat</h3>

Before building the codebase, uncomment the following lines in the <code>web/WEB-INF/web.xml</code> file to enable a filter that validates the OAuth authorization token that is embedded in each request:<br>
<br>
<pre><code>    &lt;!-- The OAuth filter that validates OAuth signature embedded in the request --&gt;<br>
    &lt;filter&gt;<br>
        &lt;filter-name&gt;OAuthFilter&lt;/filter-name&gt;<br>
        &lt;filter-class&gt;com.google.feedserver.filters.OAuthFilter&lt;/filter-class&gt;<br>
        &lt;init-param&gt;<br>
            &lt;param-name&gt;KEY_MANAGER&lt;/param-name&gt;<br>
            &lt;param-value&gt;com.google.feedserver.filters.SimpleKeyMananger&lt;/param-value&gt;<br>
        &lt;/init-param&gt;<br>
    &lt;/filter&gt;<br>
     &lt;filter-mapping&gt;<br>
         &lt;filter-name&gt;OAuthFilter&lt;/filter-name&gt;<br>
          &lt;url-pattern&gt;/*&lt;/url-pattern&gt;<br>
    &lt;/filter-mapping&gt;<br>
</code></pre>

Build and deploy the WAR file to Tomcat, use the  <code>ant tomcat</code> command.<br>
<br>
<h3>Testing OAuth Signed Requests</h3>

The easiest way to test OAuth signed requests is to write a gadget using the <code>gadgets.io.makeRequest()</code> Gadget API to sign the request withan  OAuth consumer key and to retrieve a feed.<br>
<br>
<hr />
<h1>Abdera Debugging</h1>
You can use the code that follows to debug an Abdera configuration:<br>
<br>
Abdera uses log4j, but Feed Server uses JDK logging. If you want to debug an Abdera configuration, put the <code>log4j.properties</code> file in the <code>/conf/feedserver/</code> folder:<br>
<br>
<pre><code># Set root logger level to DEBUG and its only appender to A1.<br>
log4j.rootLogger=DEBUG, A1<br>
<br>
# A1 is set to be a ConsoleAppender.<br>
log4j.appender.A1=org.apache.log4j.ConsoleAppender<br>
<br>
# A1 uses PatternLayout.<br>
log4j.appender.A1.layout=org.apache.log4j.PatternLayout<br>
log4j.appender.A1.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n<br>
<br>
log4j.logger.com.google=DEBUG<br>
</code></pre>

<hr />
<h1>SVN Code Review Process</h1>

The following instructions show you how to use a Subversion client like TortoiseSVN to do your diffs in the graphical merge tool.<br>
<br>
Because the <code>/changes</code> section changes quite often, check out a working copy:<br>
<br>
<pre><code>svn checkout https://google-feedserver.googlecode.com/svn/changes/ changes<br>
</code></pre>

You can use this to review changes. Changes can be diff'd by using TortoiseSVN. Go to the root that you want to diff, and select <code>tortoisesvn&gt;merge</code> and then in the merge dialog put the trunk URL in the to: box. These directories should be the same root (usually <code>/trunk/</code>). Enter <code>diff</code> to display the changes so that you can review each individually with the Tortoise diff command. Don't enter <code>merge</code>. You have to diff with the trunk and the best way to do that is with the merge tool without doing the merge.<br>
<br>
<h2>SVN Approval</h2>

After you receive a mail request to review a change, review it, discuss it, and when you're satisfied that it can be submitted, run the following command:<br>
<pre><code>svn ack fix-deploy-task<br>
</code></pre>

Then send a message to the user to acknowledge the change so that the person can submit. There is no automated mail sent and there is no way to automatically acknowledge using a mail response.<br>
<br>
<h2>Wiki Checkout</h2>

You can check out the Wiki separately as follows:<br>
<pre><code>svn checkout https://google-feedserver.googlecode.com/svn/wiki/ google-feedserver-wiki<br>
</code></pre>