<h1>Private Gadget Administrator's Guide</h1>

This guide provides information for administrators to use the Feed Server private gadget administrative tools:
Feed Server Client Tool, the Private Gadget Editor, and
the Domain Gadget Directory Manager. In addition, this guide describes the schemas for hosted feeds. Hosted feeds are provided by [Google Apps](http://www.google.com/apps/).

The primary use for these tools is to
support [Google Gadget](http://code.google.com/apis/gadgets/) features for Google Apps for Your Domain Premier Edition and Education Edition.
Open source software distribution for these products is available in either binary
or source for use with Linux or Windows. The binary software distribution zip file is available on
the [Downloads tab](http://code.google.com/p/google-feedserver/downloads/list) of this site. Source code
is available on the [Source tab](http://code.google.com/p/google-feedserver/source/checkout) in the `svn/trunk/resources` folder.


---

<h2>Contents</h2>



---


---

# Overview #

Private Gadgets are XML files that you can use with Google Sites and the Google Visualization API to display information.
The [google-feedserver](http://code.google.com/p/google-feedserver/) site provides the
following tools for administering private gadgets:
<ul>
<li><b>Feed Server Client Tool (FSCT)</b>. Provides a set of Linux shell or Windows batch commands that you can run from the command line to retrieve or modify feeds. Use of the FSCT commands requires that you have previously installed the Java runtime environment, which is available from <a href='http://java.sun.com/javase/downloads/?intcmp=1281'>Java.Sun.com</a>.</li>
<li><b>Private Gadget Editor (PGE)</b>. You can use the PGE gadget to create private Google Gadgets that are accessible to your own domain.</li>
<li><b>Domain Gadget Directory Manager (DGDM)</b>. You can use DGDM gadget to manage where gadgets appear in your domain's gadget directories.</li>
</ul>

This guide assumes an understanding of XML, Google Gadgets, and how to install a Java runtime environment to run Java programs from either a Linux or Windows command line.


---


---

# Feed Server Client Tool #

The Feed Server Client Tool (FSCT) provides feed administrators with a set of management tools for
managing and serving feeds.

The FSCT provides the following:

  * Binary distribution for easy setup and use
  * Create, retrieve, update, and delete (CRUD) capabilities

The sections that follow enable you to install, configure, and use the FSCT.


---

## FSCT Requirements ##

To use FSCT, you need the following:

  * Linux (any distribution where Java programs can run) or Windows (XP or Vista)
  * 512 MB RAM recommended
  * 2 MB disk space for installation of the binary version
  * JRE available from [Java.com](http://www.java.com/en/download/manual.jsp)
  * FSCT software binary download from http://code.google.com/p/google-feedserver/downloads/list


---

## FSCT Tasks ##

You can use FSCT for the following tasks:

  1. Manage feed entries: insert, retrieve, update, and delete
  1. Retrieve feeds


---

## Installing and Configuring FSCT ##

You can download the FSCT from a [zip file](http://code.google.com/p/google-feedserver/downloads/list)
that creates subordinate folders when extracted.
FSCT provides a setup file that you edit and then run to configure your operating environment.

To install and configure FSCT:

<ol>
<li>Install <a href='http://java.sun.com/javase/downloads/?intcmp=1281'>JRE</a> if you have not done so already.</li>
<li>Download the <a href='http://google-feedserver.googlecode.com/files/google-feedserver-clienttool-2.0.4.zip'>FSCT binary distribution zip file</a> and extract the contents.</li>
<li>Use a text editor to edit the <code>setupEnv.sh</code> file for Linux or the <code>setupEnv.bat</code> file for Windows and set the following parameters (you can ignore the rest of the parameters in the setupEnv file):<ul>
<li>FSCT_DOMAIN -- Set to the domain name of your Google Apps for Your Domain site.</li>
<li>FSCT_USER_NAME -- Specify the login name for your Google Account.  For most administrative tasks, this needs to be an administrator account.</li>
</ul></li>
<li>Test your installation by running the <code>./getFeed.sh Gadget</code> in Linux or <code>getFeed Gadget</code> in Windows to view Google Gadgets in your domain's public gadget directory.</li>
</ol>

In `setupEnv.sh` for Linux or in `setupEnv.bat` for Windows, the following parameters are configurable:

  * FSCT\_DOMAIN -- Domain name
  * FSCT\_USER\_NAME -- The user account to be used
  * FSCT\_FEED\_BASE -- The feed URL base
  * SERVICE\_NAME -- The name of feed service
  * AUTHN\_URL\_PROTOCOL -- Name of the protocol to use for authentication, either http or https
  * AUTHN\_URL -- The end point that handles authentication and grants authorization tokens to be used with each request


---

## FSCT Commands ##

To use each command:

  1. Ensure that `setupEnv.sh` for Linux or `setupEnv.bat` for Windows is correctly configured with your Google Apps for Your Domain user name and domain name.
  1. Run the command from the command line specifying the proper syntax.

FSCT provides the following commands for Linux (file type of `.sh`) or Windows (file type of `.bat`). The Syntax column lists Windows batch command syntax. For Linux, preface commands with `./` and specify the `.sh` file extension, for example `./getFeed PrivateGadgetSpec`:

<table border='1'>
<tr><th>Command</th><th>Description</th><th>Syntax</th><th>Example</th></tr>

<tr><td><code>deleteEntry</code></td>
<blockquote><td>Deletes an entry from a feed</td>
<td><b>deleteEntry</b> <em>feedName</em> <em>entryName</em></td>
<td><tt>deleteEntry <code>PrivateGadgetSpec</code> hello-gadget</tt></td>
</tr></blockquote>

<tr><td><code>getEntry</code></td>
<blockquote><td>Gets an entry from a feed</td>
<td><b>getEntry</b> <em>feedName</em> <em>entryName</em></td>
<td><tt>getEntry <code>PrivateGadgetSpec</code> hello-gadget</tt></td>
</tr></blockquote>

<tr><td><code>getFeed</code></td>
<blockquote><td>Gets a feed</td>
<td><b>getFeed</b> <em>feedName</em></td>
<td><tt>getFeed <code>PrivateGadgetSpec</code></tt></td>
</tr></blockquote>

<tr><td><code>insertEntry</code></td>
<blockquote><td>Inserts an entry into a feed</td>
<td><b>insertEntry</b> <em>feedName</em> <em>entityFilePath</em></td>
<td><tt>insertEntry <code>PrivateGadgetSpec</code> helloEntity.xml</tt> where <tt>helloEntity.xml</tt> has the content:<pre><entity xmlns=""><br>
<name>hello-gadget<br>
<br>
Unknown end tag for </name><br>
<br>
<br>
<specContent>@hello.xml<br>
<br>
Unknown end tag for </specContent><br>
<br>
<br>
<br>
<br>
Unknown end tag for </entity><br>
<br>
<br>
</pre>and file <tt>hello.xml</tt> has the gadget spec content.<br>
</td>
</tr></blockquote>

<tr><td><code>updateEntry</code></td>
<blockquote><td>Updates a feed entry in the Feed Server</td>
<td><b>updateEntry</b> <em>feedName</em> <em>entryName</em> <em>entityFilePath</em></td>
<td><tt>updateEntry <code>PrivateGadgetSpec</code> hello-gadget helloEntity.xml</tt></td>
</tr>
</table></blockquote>

The commands above are generic and works for any feed.  The commands below are optimized for private gadget and directory operation.
<table border='1'>
<tr><th>Command</th><th>Description</th><th>Syntax</th><th>Example</th></tr>

<tr><td><code>insertGadgetSpec</code></td>
<blockquote><td>Inserts a gadget spec into the domain's private gadget spec feed</td>
<td><b>insertGadgetSpec PrivateGadgetSpec</b> <em>gadgetName</em> <em>gadgetSpecFileName</em></td>
<td><tt>insertGadgetSpec <code>PrivateGadgetSpec</code> hello-gadget hello.xml</tt></td>
</tr></blockquote>

<tr><td><code>updateGadgetSpec</code></td>
<blockquote><td>Updates a gadget spec in the domain's private gadget spec feed</td>
<td><b>updateGadgetSpec PrivateGadgetSpec</b> <em>gadgetName</em> <em>gadgetSpecFileName</em></td>
<td><tt>updateGadgetSpec <code>PrivateGadgetSpec</code> hello-gadget hello.xml</tt></td>
</tr></blockquote>

<tr><td><code>publishGadget</code></td>
<blockquote><td>Publishes a private gadget in the domain's private gadget directory</td>
<td><b>publishGadget</b> <em>privateDirectoryFeedName</em> <em>privateGadgetSpecFeedName/gadgetName</em></td>
<td><tt>publishGadget <code>PrivateGadget</code> <code>PrivateGadgetSpec</code>/hello-gadget</tt></td>
</tr>
</table></blockquote>

Note:
  1. All feeds have permissions defined on them.  FSCT succeeds only if a user is allowed to perform the operation (so that a password can be entered).
  1. Gadget name has to be unique in the gadget spec feed.



---

## Troubleshooting FSCT ##

The following issues can occur while using FSCT commands.


---

### Bad Request ###

The bad request error occurs if you try to add a gadget that already exists or if you specify an FSCT command with the incorrect parameters.

`Exception in thread "main" com.google.feedserver.util.FeedServerClientException: com.google.gdata.util.InvalidEntryException: Bad Request invalid_input`


You may need to scroll down through the list of gadgets in the Domain Gadget Directory Manager to find a gadget.


---

### Gadget Already Exists ###

If a gadget has already been published and you attempt to publish the gadget more than once, the following error occurs:

`Exception in thread "main" com.google.feedserver.util.FeedServerClientException: com.google.gdata.util.InvalidEntryException: Bad Request Gadget already exists`


---

### Gadget Specified Could Not Be Fetched ###

If a command specifies an incorrect feed or gadget name, the following error occurs:

`Exception in thread "main" com.google.feedserver.util.FeedServerClientException: com.google.gdata.util.ServiceException: Internal Server Error Gadget specified could not be fetched`

Ensure that you specified the correct feed name and that the gadget name exists. This error occurs for the 'getEntry' command.


---

### Invalid Credentials ###

The invalid credentials error occurs when the FSCT is not correctly configured:

`Exception in thread "main" com.google.gdata.client.GoogleService$InvalidCredentialsException: Invalid credentials`

Ensure that you have edited `setupEnv.sh` for Linux or `setupEnv.bat`
for Windows and have set the following values:

  * `FSCT_DOMAIN`. Set to the domain name for your Google Apps for Your Domain account.
  * `FSCT_USER_NAME`. Set to your user account name for your Google Apps for Your Domain account.


---

### Not Found Exception ###

The resource not found error occurs if you enter incorrect command line information:

`Exception in thread "main" com.google.feedserver.util.FeedServerClientException: com.google.gdata.util.ResourceNotFoundException: Not Found`


This error can occur if the domain is not correct, or the entry or feed name
is misspelled (feed and entry names are case sensitive in Linux and in Windows).


---

### Unauthorized Exception ###

The forbidden service error occurs when an access control list (ACL) check fails:

`Exception in thread "main" com.google.feedserver.util.FeedServerClientException: com.google.gdata.util.ServiceForbiddenException: Forbidden Unauthorized`


Feeds that have ACLs set may prevent reading or writing by the account provided.
You may be able to change the ACL for the resource by editing the ACL feed. For information on ACLs, see the Acl feed in the "Schemas of Hosted Feeds" section.

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)

---


---

# Using FSCT to Manage Private Gadgets #

The FSCT commands enable you to perform the following tasks to manage private gadgets:

  * Manage private gadgets and feeds
  * Create private gadget categories
  * Publish a private gadget to the Private Directory (for information on the Private Directory, see "Domain Gadget Directory Manager")
  * Unpublish a private gadget from the Private Directory

<b>Note</b>: The commands shown in the sections that follow are for Linux.
Windows users can enter the command itself without a file type.
For example, to run the equivalent Windows command for `./insertEntry.sh`,
enter `insertentry` (Windows commands are not case sensitive).

In the syntax statements that follow, the parameters are:

<table border='1'>
<tr><th>Parameter</th><th>Description</th></tr>
<tr><td><em>categoryName</em></td><td>A category in private directory under which private gadgets appear. The category name corresponds to the <code>category</code>
attribute of the <code>ModulePref</code> element in gadget spec.</td></tr>
<tr><td><em>entityFile</em></td><td>Path to an XML file containing an entity used in a command.</td></tr>
<tr><td><em>feedName</em></td>
<td>Possible feed values:<br>
<ul><li><code>PrivateGadgetSpec</code>. Feed that stores private gadget specifications (gadget XML files).<br>
</li><li><code>PrivateGadget</code>. Private gadget directory feed.<br>
</li><li><code>PrivateGadgetCategory</code>. Feed that stores categories of gadgets in a private gadget directory.<br>
</td></tr>
<tr><td><em>gadgetName</em></td><td>The name of a gadget.</td></tr>
<tr><td><em>gadgetSpecFile</em></td><td>The path to a file relative to where FSCT commands are execute that contains a gadget's spec<br>
By default the FSCT commands assume that the file is saved in the 'scripts' folder</td></tr>
<tr><td><em>privateDirectory</em></td><td>The private directory to which you publish your gadgets to or unpublish from.</td></tr>
<tr><td><em>gadgetId</em></td><td>The unique id Feed Server assigns to a published gadget. Use <b>getFeed</b> on PrivateGadget feed to find it.</td></tr>
</table></li></ul>


---

## Add a Private Gadget ##

> | <b>Linux Syntax:</b> `./insertGadgetSpec.sh` <em>feedName</em> <em>gadgetName</em> <em>gadgetSpecFile</em><br /><b>Windows Syntax:</b> `insertGadgetSpec` <em>feedName</em> <em>gadgetName</em> <em>gadgetSpecFile</em> |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

To add a private gadget to your domain:

  * Run `./insertGadgetSpec.sh PrivateGadgetSpec` <em>gadgetName</em> <em>gadgetSpecFile</em>

> After inserting the gadget, FSCT echoes back the inserted entity. For example:

```
    <?xml version="1.0" encoding="UTF-8" ?>
    <Module>
    <ModulePrefs title="Sample Enterprise Gadget" author="phedra" category="finance" />
    <Content type="html">
    <![CDATA[
    <a href="javascript:getData()">Get Data&lt;/a>
    <script type="text/javascript">
    function getData() {
    var params = {};
    ...
```



---

## View Private Gadget Entry ##

> |<b>Linux Syntax:</b> `./getEntry.sh` <em>feedName</em> <em>gadgetName</em><br /><b>Windows Syntax:</b> `getEntry` <em>feedName</em> <em>gadgetName</em> |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------|

To display the XML code for a single gadget:

  * Run `./getEntry.sh PrivateGadgetSpec`/<em>gadgetName</em>

> The gadget entity displays in the console. (An entity refers to the contents of the gadget spec, which is defined with the `<entity>` element block.)


---

## View All Gadgets ##

> | <b>Linux Syntax:</b> `./getFeed.sh` <em>feedName</em><br /><b>Windows Syntax:</b> `getFeed` <em>feedName</em> |
|:--------------------------------------------------------------------------------------------------------------|

To display the XML code for all gadgets:

  * To view gadget source, run `./getFeed.sh PrivateGadgetSpec`
  * To find a gadget ID, run  `./getFeed.sh PrivateGadget`

> Gadget entities display in the console.

<b>Note</b>:
  * By default, FSCT only returns a maximum of 20 entries.  To retrieve more, use parameter "start-index=N" and "max-results=M" on the feed URL where N is a base-1 starting index and max-results is a number from 1 to 20.
  * If there are many gadgets, the <b>getFeed</b> command listing can be many pages. In Windows, in the Command Prompt <b>Properties</b> menu, set the <b>Screen Buffer Size</b> to a number large enough to contain this output, such as to 9999 rows. You can then copy the data from the Command Prompt to an editor such as Notepad to search for a gadget entry.

An example `getFeed` listing of the PrivateGadget feed starts as follows:
```
<entities>
 <entity>
    <screenshot></screenshot>
    <submit_date>1237487950081</submit_date>
    <url>http://www.google.com/a/feeds/server/g/domain/example.com/PrivateGadgetSpec/hello.xml</url>
    <country>all</country>
    <id>http://feedserver-enterprise.googleusercontent.com/a/example.com/g/PrivateGadget/03655085350586526872</id>
    <author_email>developer@example.com</author_email>
    <title>hello world example</title>
    <thumbnail></thumbnail>
    <description></description>
    <localmetadata repeatable="true">
      <title>hello world example</title>
      <screenshot></screenshot>
      <thumbnail></thumbnail>
      <description></description>
      <language>all</language>
      <country>all</country>
    </localmetadata>
    <view repeatable="true">
      <name>default</name>
      <type>html</type>
    </view>
    <language>all</language>
    <item_type>gadget</item_type>
  </entity>
  ...
```


---

## Update a Private Gadget ##

> | <b>Linux Syntax:</b> `./updateGadgetSpec.sh` <em>feedName</em> <em>gadgetName</em> <em>gadgetSpecFile</em><br /><b>Windows Syntax:</b> `updateGadgetSpec` <em>feedName</em> <em>gadgetName</em> <em>gadgetSpecFile</em> |
|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

To update a gadget in the `PrivateGadgetSpec` feed source:

  * Run `./updateGadgetSpec.sh PrivateGadgetSpec` <em>gadgetName</em> <em>gadgetSpecFile</em>

> The updated gadget entity displays in the console. This command enables you to change the XML code content in the for <em>gadgetSpecFile</em> the gadget. Any part of the gadget spec can be changed as well as the functionality for the gadget.


---

## Delete a Private Gadget ##

> | <b>Linux Syntax:</b> `./deleteEntry.sh` <em>feedName</em> <em>gadgetName</em> <em>gadgetSpecFile</em><br /><b>Windows Syntax:</b> `deleteEntry` <em>feedName</em> <em>gadgetName</em> |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

  * Run `./deleteEntry.sh PrivateGadgetSpec` <em>gadgetName</em>


---

## Publish a Private Gadget to the Private Directory ##

> | <b>Linux Syntax:</b> `./publishGadget.sh` <em>privateDirectory</em> <em>feedName/gadgetName</em><br /><b>Windows Syntax:</b> `publishGadget` <em>privateDirectory</em> <em>feedName/gadgetName</em> |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

  * Run `./publishGadget.sh PrivateGadget PrivateGadgetSpec`/<em>gadgetName</em>

Publishing a gadget is required for the gadget to appear in the Private Directory. Published gadgets can then be added to a Google Sites page by users in a domain within Google Apps for Your Domain Premier Edition or Education Edition.


---

## Unpublish a Gadget ##

> | <b>Linux Syntax:</b> `./deleteEntry.sh PrivateGadget` <em>gadgetId</em><br /><b>Windows Syntax:</b> `deleteEntry PrivateGadget` <em>gadgetId</em> |
|:--------------------------------------------------------------------------------------------------------------------------------------------------|

You can unpublish a gadget to remove it from domain's private gadget directory.

<b>Note</b>: To find the gadget you want to unpublish, you need to find its gadget ID value.

To unpublish a gadget:
<ol>
<li>Run the <b>getFeed PrivateGadget</b> command to locate a gadget's ID value (in the <code>&lt;id&gt;</code> element).<br>
<br>
For example:<br>
<pre><code>    $ ./getFeed.sh PrivateGadget<br>
    The password cannot be null or blank<br>
    Password:<br>
    &lt;entities&gt;<br>
      &lt;entity&gt;<br>
        &lt;screenshot&gt;&lt;/screenshot&gt;<br>
        &lt;submit_date&gt;1237476364974&lt;/submit_date&gt;<br>
        &lt;url&gt;http://feedserver-enterprise.googleusercontent.com/a/example.com/g/PrivateGadgetSpec/mygadget.xml&lt;/url&gt;<br>
        &lt;country&gt;all&lt;/country&gt;<br>
        &lt;id&gt;http://feedserver-enterprise.googleusercontent.com/a/example.com/g/PrivateGadget/056536884581709698&lt;/id&gt;<br>
    ...<br>
</code></pre>
<blockquote></li>
<li>Run the <b>deleteEntry</b> command, specify the <code>PrivateGadget</code> feed source, and the gadget ID.</blockquote>

For example:<br>
<pre><code>    $ ./deleteEntry.sh PrivateGadget 056536884581709698<br>
    The password cannot be null or blank<br>
    Password:<br>
<br>
    $<br>
</code></pre>
<blockquote></li>
</ol></blockquote>


---

## Create a Private Gadget Category ##

> | <b>Linux Syntax:</b> `./insertEntry.sh PrivateGadgetCategory` <em>entityFile</em><br /><b>Windows Syntax:</b> `insertEntry PrivateGadgetCategory` <em>entityFile</em> |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<b>Note</b>: For a gadget to appear in a category, the gadget spec must contain the `category` attribute in the
`<ModulePref>` element.

For example:

```
<ModulePrefs title="Sample Enterprise Gadget" author="phedra" category="Finance" />
```

To create a gadget category:

<ol>
<li>Create an entity XML file for the category.<br>
<br>
An example <code>financeEntity.xml</code> entity file is:<br>
<br>
<pre><code>    &lt;entity xmlns=""&gt;<br>
      &lt;name&gt;Finance&lt;/name&gt;<br>
      &lt;category repeatable="true"&gt;<br>
        &lt;locale&gt;en&lt;/locale&gt;<br>
        &lt;displayName&gt;Finance&lt;/displayName&gt;<br>
      &lt;/category&gt;<br>
    &lt;/entity&gt;<br>
</code></pre>
<blockquote></li>
<li>Run the <b>insertEntry.sh</b> command for Linux or the <b>insertEntry.bat</b> command for Windows to add the category from the gadget to the Domain Gadget Directory Manager.</blockquote>

<pre><code>    ./insertEntry.sh PrivateGadgetCategory financeEntity.xml<br>
</code></pre>
<blockquote></li>
</ol></blockquote>


---

## Delete a Private Gadget Category ##

> | <b>Linux Syntax:</b> `./deleteEntry.sh PrivateGadgetCategory` <em>categoryName</em><br /><b>Windows Syntax:</b> `deleteEntry PrivateGadgetCategory` <em>categoryName</em> |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

Deletes a gadget category.

For example:

`./deleteEntry.sh PrivateGadgetCategory Finance`

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)


---


---

# Using FSCT to Manage Feed Access #

## Using High Level Tool ##

### For Per Domain Feeds ###

To set the ACLs of a resource, you execute a command like this:

`./setAcl.sh PrivateGadgetSpec crud+john.doe@example.com`

which adds create, retrieve, update and delete access to user `john.doe@example.com` to the per domain feed `PrivateGadgetSpec`.

To remove access, you use minus as opposed to plus.  For example:

`./setAcl.sh PrivateGadgetSpec d-john.doe@example.com`

which removes delete access from user `john.doe@example.com` on per domain feed `PrivateGadgetSpec`.

You can verify the current ACLs by doing:

`./getAcl.sh PrivateGadgetSpec`

`./getEntry.sh acl PrivateGadgetSpec`

To set the ACLs for an entry, you would use `<feedName>/<entryName>` as the resource.  For example,

`./setAcl.sh PrivateGadgetSpec/hello.xml crud-john.doe@example.com`

which removes all access from user `john.doe@example.com` on a specific private gadget call `hello.xml`.

### For Per User Feeds ###

To set ACLs on per user resources, do exact the same as the above except use `getUserAcl.sh` and `setUserAcl.sh`.  For example,

`./setUserAcl.sh PrivateGadgetSpec r+jane.doe@example.com`

adds read access to user `jane.doe@example.com` to current user's `PrivateGadgetSpec` feed.

There is also a specific tool for sharing user's own private gadget with other users.  For example,

`./shareUserGadget.sh hello.xml friend@example.com colleague@example.com`

makes current user's own gadget `hello.xml` readable by `friend@example.com` and `colleague@example.com`.

To verify the ACLs on a specific user gadget, do the following:

`./getUserEntry.sh acl PrivateGadgetSpec%2Fhello.xml`

where "%2F" is "/" URL encoded.

To remove sharing, just use `unshareUserGadget.sh`.

### General Command Syntax ###

`getAcl.sh <resource>`

`getUserAcl.sh <resource>`

`setAcl.sh <resource> <acl>{,<acl>}*`

`setUserAcl.sh <resource> <acl>{,<acl>}*`

`shareUserGadget.sh <gadgetName> <principal>{,<principal>}*`

`unshareUserGadget.sh <gadgetName> <principal>{,<principal>}*`

where `resource` is either `<feedName>` or `<feedName>/<entryName>`, `acl`  in the format of `{c,r,u,d}{+|-}<principal>` and `principal` the email address of an individual or group.

For example,

`setUserAcl.sh PrivateGadgetSpec/hello.xml crud+project1@example.com,r+partner.guy@partner.com`

adds full access to users in group `project1@example.com` and read access to user `partner.guy@partner.com` to private gadget called `hello.xml`.

## Using Low Level Tool ##

Every hosted feed has an access control list (ACL) associated with it to control which users can do which operations on the feed and its entries. All hosted feeds have a default ACL that allows domain users to read from a feed and the domain's administrators to write to the feed. You can override a default ACL to suit the needs of your domain.

The following is an example of setting the ACL for the PrivateGagetSpec feed, which is the `aclEntity.xml` listing:
```
<entity xmlns="">
  <name>PrivateGadgetSpec-acl</name>
  <resourceInfo>
    <resourceType>feed</resourceType>
    <resourceRule>PrivateGadgetSpec</resourceRule>
  </resourceInfo>
  <authorizedEntities repeatable="true">
    <operation>create</operation>
    <entities repeatable="true">DOMAIN_ADMIN</entities>
    <entities repeatable="true">gadget-dev@example.com</entities>
  </authorizedEntities>
  <authorizedEntities>
    <operation>retrieve</operation>
    <entities repeatable="true">DOMAIN_USERS</entities>
  </authorizedEntities>
  <authorizedEntities>
    <operation>update</operation>
    <entities repeatable="true">DOMAIN_ADMIN</entities>
    <entities repeatable="true">gadget-dev@example.com</entities>
  </authorizedEntities>
  <authorizedEntities>
    <operation>delete</operation>
    <entities repeatable="true">DOMAIN_ADMIN</entities>
    <entities repeatable="true">gadget-dev@example.com</entities>
  </authorizedEntities>
</entity>
```

Execute this command to create the ACL the first time:
```
./insertEntry.sh acl aclEntity.xml
```

Then the `PrivateGadgetSpec` feed can be:
  * Inserted into by a domain's administrators, and all users on the group gadget-dev@example.com
  * Retrieved by all users in the domain
  * Updated by domain's administrators, and all users on the group gadget-dev@example.com
  * Deleted from by domain's administrators, and all users on the group gadget-dev@example.com

You can use the previous example as a template to produce an entity file specific to your needs.  Here are the valid values you can use for the "entities" element:
  * DOMAIN\_USERS: Any user in the domain
  * DOMAIN\_ADMIN: Any administrator of the domain
  * DOMAIN\_INDIVIDUAL: The current logged in user (has to belong to the domain and match the owner of the user feed)
  * ANY\_INDIVIDUAL: The current logged in user (has to match the owner of the user feed; can be out of the domain)
  * ANYONE: Any logged in user, in or out of the domain
  * User Email address: Any individual user's email address
  * Group email address: Email address of a group (go to [https://www.google.com/a/cpanel/example.com/GroupList](https://www.google.com/a/cpanel/example.com/GroupList) to manage groups)

To update an ACL, execute the following command:
```
./updateEntry.sh acl PrivateGagetSpec-acl aclEntity.xml
```

If you want to change the ACL of another feed, for example, the PrivateGadgetCategory, create another ACL entity file and plug the feed name into the `<resourceRule>` element.

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)


---


---

# Schemas of Hosted Feeds #

The following feed sources are available with Google Apps.

<table border='1'>

<tr>
<blockquote><th>Feed Name</th><th>Entity Schema</th><th>Example</th>
</tr></blockquote>

<tr>
<blockquote><td><code>PrivateGadget</code></td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;url&gt;{internal URL to private gadget}&lt;/url&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;url&gt;http://feedserver-enterprise.googleusercontent.com<br>
/a/example.com/g/PrivateGadgetSpec/hello.xml&lt;/url&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
</tr></blockquote>

<tr>
<blockquote><td><code>PrivateGadgetCategory</code></td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;{unique name of category}&lt;/name&gt;<br>
  &lt;category repeatable="true"&gt;<br>
    &lt;locale&gt;en&lt;/locale&gt;<br>
    &lt;displayName&gt;{display name of category}&lt;/displayName&gt;<br>
  &lt;/category&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;Finance&lt;/name&gt;<br>
  &lt;category repeatable="true"&gt;<br>
    &lt;locale&gt;en&lt;/locale&gt;<br>
    &lt;displayName&gt;Finance&lt;/displayName&gt;<br>
  &lt;/category&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
</tr></blockquote>

<tr>
<blockquote><td><code>PrivateGadgetSpec</code></td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;{unique name of gadget}&lt;/name&gt;<br>
  &lt;specContent&gt;@{path to gadget spec file}&lt;/specContent&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;hello-gadget&lt;/name&gt;<br>
  &lt;specContent&gt;@hello.xml&lt;/specContent&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
</tr></blockquote>

<tr>
<blockquote><td><code>Acl</code></td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;{feedName}-acl&lt;/name&gt;<br>
  &lt;resourceInfo&gt;<br>
    &lt;resourceType&gt;feed&lt;/resourceType&gt;<br>
    &lt;resourceRule&gt;{feedName}&lt;/resourceRule&gt;<br>
  &lt;/resourceInfo&gt;<br>
  &lt;authorizedEntities repeatable="true"&gt;<br>
    &lt;operation&gt;{operation}&lt;/operation&gt;<br>
    &lt;entities repeatable="true"&gt;{principal}&lt;/entities&gt;<br>
    ...<br>
  &lt;/authorizedEntities&gt;<br>
  ...<br>
&lt;/entity&gt;<br>
</code></pre>
Operation can be:<br>
</blockquote><ul><li>create<br>
</li><li>retrieve<br>
</li><li>update<br>
</li><li>delete</li></ul>

Principal can be:<br>
<ul><li>DOMAIN_USERS: Any user in the domain<br>
</li><li>DOMAIN_ADMIN: Any administrator of the domain<br>
</li><li>DOMAIN_INDIVIDUAL: The current logged in user (has to belong to the domain and match the owner of the user feed)<br>
</li><li>ANY_INDIVIDUAL: The current logged in user (has to match the owner of the user feed; can be out of the domain)<br>
</li><li>ANYONE: Any logged in user, in or out of the domain<br>
</li><li>User Email address: Any individual user's email address<br>
</li><li>Group email address: Email address of a group (go to <a href='https://www.google.com/a/cpanel/example.com/GroupList'>https://www.google.com/a/cpanel/example.com/GroupList</a> to manage groups)<br>
</li></ul><blockquote></td>
<td>
<pre><code>&lt;entity xmlns=""&gt;<br>
  &lt;name&gt;PrivateGadgetSpec-acl&lt;/name&gt;<br>
  &lt;resourceInfo&gt;<br>
    &lt;resourceType&gt;feed&lt;/resourceType&gt;<br>
    &lt;resourceRule&gt;PrivateGadgetSpec&lt;/resourceRule&gt;<br>
  &lt;/resourceInfo&gt;<br>
  &lt;authorizedEntities repeatable="true"&gt;<br>
    &lt;operation&gt;create&lt;/operation&gt;<br>
    &lt;entities repeatable="true"&gt;DOMAIN_ADMIN&lt;/entities&gt;<br>
    &lt;entities repeatable="true"&gt;gadget-dev@example.com&lt;/entities&gt;<br>
  &lt;/authorizedEntities&gt;<br>
  &lt;authorizedEntities&gt;<br>
    &lt;operation&gt;retrieve&lt;/operation&gt;<br>
    &lt;entities repeatable="true"&gt;DOMAIN_USERS&lt;/entities&gt;<br>
  &lt;/authorizedEntities&gt;<br>
  &lt;authorizedEntities&gt;<br>
    &lt;operation&gt;update&lt;/operation&gt;<br>
    &lt;entities repeatable="true"&gt;DOMAIN_ADMIN&lt;/entities&gt;<br>
    &lt;entities repeatable="true"&gt;gadget-dev@example.com&lt;/entities&gt;<br>
  &lt;/authorizedEntities&gt;<br>
  &lt;authorizedEntities&gt;<br>
    &lt;operation&gt;delete&lt;/operation&gt;<br>
    &lt;entities repeatable="true"&gt;DOMAIN_ADMIN&lt;/entities&gt;<br>
    &lt;entities repeatable="true"&gt;gadget-dev@example.com&lt;/entities&gt;<br>
  &lt;/authorizedEntities&gt;<br>
&lt;/entity&gt;<br>
</code></pre>
</td>
</tr>
</table></blockquote>

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)


---


---

# Private Gadget Editor #

The Private Gadget Editor (PGE) gadget enables you to create, change, and delete Google Gadgets. The PGE is a gadget that can be
added only to a Google Sites page.

Private gadgets are usable only by Google Apps for Your Domain Premier
Edition or Education Edition. Private gadgets are gadgets that are available only to users in a domain.

To add the PGE gadget to a Google Sites page:

<ol>
<li>Click <b>Create new page</b>.</li>
<li>Click <b>Start Page</b> and specify a page name.</li>
<li>Click one of the following choices to add the gadget:<br>
<ul>
<blockquote><li>The <b>Add personal gadgets</b> link.</li>
<li>In the <b>Gadgets in this area are only visible to you</b> dashed area.</li></ul>
The <b>Select a gadget</b> window appears.</li>
<li>Click <b>Add gadget by URL</b>.</li>
<li>Click the edit box, type in this value, and click <b>Add</b>: <code>http://google-feedserver.googlecode.com/svn/trunk/resources/gadgets/private-gadget-editor/spec.xml</code></li>
<li>In the gadget's title bar, click the maximize button to use the gadget in profile view. </li>
<li>To create a gadget, paste in a gadget in the editor.<br>
To edit an existing gadget, click <b>Open URL</b> to load a gadget spec from a public URL, or click <b>Select to open</b> to open an existing private gadget to edit.</li>
</ol></blockquote>

After creating and saving a gadget in the PGE, use the Domain Gadget Directory Manager to publish
the gadget to the domain's private gadget directory so that users can access it in Google Apps.

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)


---


---

<a></a>
# Domain Gadget Directory Manager #

The Domain Gadget Directory Manager (DGDM) gadget enables domain administrators to manage a domain's public and private gadget directory.
The DGDM is itself a gadget that you add to a Google Sites page. The DGDM gadget only works with Google Sites.


---

## Add the DGDM Gadget to Google Sites ##

To add the DGDM gadget to a Google Sites page:

  1. Start Google Sites
  1. Click the <b>Create new page</b> button.
  1. Click <b>User Start Page</b> and specify a page name.
  1. Click the <b>Add personal gadgets</b> link. The <b>Select a gadget</b> window appears.
  1. Click <b>Add gadget by URL</b>.
  1. Click the edit box, type in this value, and click <b>Add</b>: <p><code>http://google-feedserver.googlecode.com/svn/trunk/resources/gadgets/domain-gadget-directory-manager/spec.xml</code></p>


---

### Using DGDM ###

The Domain Gadget Directory Manager provides the following tabs:

<ul>
<a href='Hidden comment: 
<li><b>Public Directory

Unknown end tag for </b>

. Allows an administrator to manage a domain"s public gadget directory. Administrators can choose to use no restrictions on public gadgets or use a white list to include only specified public gadgets or use a black list to filter out undesired public gadgets.

Unknown end tag for </li>


'></a><br>
<li><b>Private Directory</b>. Allows an administrator to manage a domain's private gadget directory which is visible only to the domain.  Administrators can publish private gadgets to the private gadget directory and/or unpublish from it.</li>
<li><b>Private Categories</b>. Allows an administrator to manage a domain's private gadget categories. Administrators can create or remove private categories under which private gadgets will appear. You can create a category for a gadget by setting the <b>category</b> attribute in the <code>&lt;ModulePrefs&gt;</code> element<br>
in gadget XML code.<br>
<br>
For example:<br>
<br>
<pre><code>&lt;ModulePrefs title="View Data Gadget"<br>
    category="Finance"<br>
    ... /&gt;<br>
</code></pre>

Choose a category that best matches the <b>content</b> of your gadget.  Refer to <a href='http://code.google.com/support/bin/answer.py?hl=en&answer=55132'>this page</a> for more details.<br>
</li>
<li><b>Directory Preview</b>. Preview directory changes when there is a delay after changes are made in DGDM (or FSCT) and when they appear in an end user's gadget directory UI.</li>
</ul>

<b>Note</b>: Only domains using Google Apps Premier Edition or Education Edition can have private gadgets.

[Back to top.](http://code.google.com/p/google-feedserver/wiki/PrivateGadgetAdministratorsGuide)