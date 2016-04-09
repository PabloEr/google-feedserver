<h1>Atom Protocol and Google Data API Overview</h1>

Apache Abdera is a framework for creating Atom Publishing (AtomPub) Protocol  for servers and clients. The Google Feed Server is an implementation of Abdera that is easy to use.

Google Feed Server implements a simple back end for data adapters that allows a developer to quickly deploy a feed for an existing data source such as a database.

---

<h2>Contents</h2>



---

# Google Data API and the Atom Publishing Protocol #

The Google Data API is a set of extensions to AtomPub that Google developed while AtomPub was in the standards process. The AtomPub specification was not intended to be a total solution. As an early adopter (from .3 on) Google provided enhancements such as, optimistic concurrency, queries, common elements or "kinds," and authentication. The Google Data API is a widely used and documented AtomPub system.

For information, see [About the Google Data APIs](http://code.google.com/apis/gdata/overview.html#Motivation).


---

# Google Feed Server Extensions to Abdera #

The following sections describe the Google Feed Server extensions to Abdera.

## Authentication ##

Authentication is a very important part of of the implementation of the Feed Server. The Abdera approach to server-side authentication support is to simply depend on the web server to authenticate users and provide a simple API for getting the user information. Then it is up to the developer to design their authorization system. The Google Feed Server contains Java servlet filters that handle authentication for the Google ClientLogin and OAuth protocols.

Abdera ships with a client library for authenticating with the Google ClientLogin protocol as well as WSSE web service security. Google Feed Server adds client side OAuth support as well. The existing Google Data API client libraries provide limited support for ClientLogin, AuthSub, and OAuth. The Feed Server ignores AuthSub headers but the client authentication attempts to send OAuth headers by the same methods. See [Using "AuthSub" Authentication with the JavaScript Client Library](http://code.google.com/apis/gdata/authsub-js.html) for an overview of how the AuthSub system works with the JavaScript client. The client works the same when handling an OAuth token.

Abdera also includes server and client-side support for signing and encrypting messages. This message-level encryption is useful in situations where you want non-repudiation or cannot rely on TLS to protect your content.

## Common Data Elements ##

Google has created specialized schemas for each service that uses GData (an example is the event kind for calendars) and many of these are part of the GData 'core' and used across many systems. See http://code.google.com/apis/gdata/elements.html for more information. It is generally up to the feed designer to judge where to use extension elements. However, the current trend is to treat the data that is being published in the feed as an opaque blob that is wrapped with the AtomPub envelope. It may be useful to feed implementers to fully serialize their data into XML and use extension elements but this requires the most work. In the end, we suggest that feed designers try to simplify the representations of their back-end data sources and stick to common elements instead of creating their own schemas.

## Google Client Library Support ##

Developers can use the core aspects of the [Google Data APIs Client Libraries](http://code.google.com/apis/gdata/clientlibs.html) with the Google Feed Server. One example of this is the , [!JavaScript client library](http://code.google.com/apis/gdata/client-js.html). Because browsers can submit GET and POST requests, but are unable to issue PUT and DELETE requests, the Feed Server includes a method override filter. The JavaScript library sends a DELETE over a POST request, which the server interprets as a DELETE.

The Google client libraries also have an optional XD2 filter to support cross-domain access.

Many of the higher level functions of the Google Data API client libraries such as for calendar entries, were designed to work specifically with the services on Google.com. Therefore, not all such services are emulated in [google-feedserver](http://code.google.com/p/google-feedserver/).

## Queries ##

Google follows Abdera development toward the OpenSearch format.

## Optimistic Concurrency ##

Google supports the Etag system in the Abdera AtomPub protocol, not the Google Data API Optimistic Concurrency system.