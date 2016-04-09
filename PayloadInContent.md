<h2>Contents</h2>



---

# Payload In Content #

Google Feed Server uses a simple payload format called "payload in content." Information about the payload is
described in the [Wikipedia Atom article](http://en.wikipedia.org/wiki/Atom_(standard)).
<ul>
<li>A payload is put in the <code>&lt;content&gt;</code> element as <code>type application/xml</code></li>
<li>A property is represented as an element of <code>&lt;name&gt;value&lt;/name&gt;</code></li>
<li>A <code>repeatable</code> property is represented as an element of <code>&lt;name repeatable="true"&gt;value0&lt;/name&gt;&lt;name&gt;value1&lt;/name&gt;...</code></li>
<li>Properties can be nested</li>
<li>Everything inside <code>&lt;content&gt;</code> is treated as data and everything outside as metadata</li>
</ul>

The payload in content format is Atom compliant and has the following properties:
<ul>
<li>No custom extension elements are required</li>
<li>No custom namespaces are required</li>
<li>The simple XML format maps to JavaBeans and JSON easily</li>
<li>No Google Data API Java client library revision is needed when new payload JavaBeans are added</li>
</ul>


---

## Atom Example ##

A sample contact feed in Atom XML:

```
<feed>
  ...
  <entry>
    ...
    <content type="application/xml">
      <entity xmlns="">
        <id>1234</id>
        <firstName>Polly</firstName>
        <lastName>Hedra</lastName>
        <nickName repeatable="true">Planes</nickName>
        <nickName>Solid</nickName>
      </entity>
    </content>
  </entry>
</feed>
```


---

## JSON Example ##

```
{"feed": {"entry": [{
  "content": {
    "entity": {
      "id": 1234, "firstName": "Polly", "lastName": "Hedra", nickName: [
        "Planes", "Solid"
      ]
    }
  },
  ...
]
```


---

## Java Example ##

Sample Java client code in which property type conversions are done automatically.

```
// Contact JavaBean
public class Contact {
  protected String id;
  protected String firstName;
  protected String lastName;
  protected String[] nickName;

  public String getFirstName() {
    return firstName;
  }
  public void setFirstName(String s) {
    firstName = s;
  }

  // create getter/setter for the other two properties
  ...
}

// fill a bean with the payload in content of an entry
FeedEntry entry = service.getEntry("...", FeedEntry.class);
Contact contact = new Contact();
ContentUtil contentUtil = new ContentUtil();
contentUtil.fillBean(entry, contact);

// put a bean into the content of an entry
Contact contact = new Contact();
contact.setFirstName("Polly");
OtherContent content = contentUtil.createXmlContent(contact);
FeedEntry entry = new FeedEntry();
entry.setContent(content);
```


---

## JavaScript Example ##

Sample JavaScript client code:

```
function search(userId) {
  var service = new google.gdata.client.FeedServerService('employees', 'employee-search');
  service.getFeed('http://...feedUrl...' + userId, function(response) {
    var employee = response.entry.content.entity;
    var content = [];
    content.push('<table>');
    content.push('<tr><th align="right">Location</th><td>', employee.location, ' ', employee.roomNumber, '</td></tr>');
    content.push('<tr><th align="right">Name</th><td>', employee.firstName, ' ', employee.lastName, '</td></tr>');
    content.push('<tr><th align="right">Job Title</th><td>', employee.jobTitle, '</td></tr>');
    content.push('<tr><th align="right">Office Phone</th><td>', employee.phoneOffice, '</td></tr>');
    content.push('</table>');
    document.getElementById('employee-profile').innerHTML = content.join('');
  }, showError);
  document.getElementById('employee-profile').innerHTML = 'Searching for ' + userId + ' ...';
};
```