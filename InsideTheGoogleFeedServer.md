<h1>Inside the Google Feed Server</h1>

---


This document is for developers who want to understand the Google Feed Server framework and to write sample implementations.

The following sections require an understanding of the
[Apache Abdera framework](http://cwiki.apache.org/confluence/display/ABDERA/Documentation).

---

<h2>Contents</h2>


---


# Implementation Tasks #

  1. Build a server based on the Apache Abdera framework that handles the Atom protocol.
  1. Build an extensible mechanism to convert data from any data source into an Atom feed without writing custom code to handle the details of the Atom protocol.
  1. Build a server with no dependence between the Atom protocol handling and the mechanism of getting data into or out of data sources.  (This task separates Tasks 1 and 2.)
  1. Support multiple namespaces.
  1. Provide loose coupling between configuring a feed and an adapter.
  1. Support signed requests.

**Feed Server Components**
  * Abdera-based Atom protocol server
> Apache Abdera provides a framework to build servers to handle the Atom protocol. Google Feed Server uses this framework to build an Atom server. This is a very thin layer of code that uses the Abdera framework to ensure that data going into or out of the server conforms to the Atom protocol.
  * Data adapter framework
> Adapters interface with the data sources to perform CRUD (Create, Retrieve, Update, and  Delete) operations on data. Adapters working with new data sources can be written simply by implementing the `CollectionAdapter` interface (or extending `AbstractCollectionAdapter` OR `AbstractEntityCollectionAdapter`)


---

# Multiple Namespace Support #

The Google Feed Server supports multiple namespaces on a single server. This is achieved with collection adapters and server configurations that understand namespaces. The feed and adapter configurations are stored for each namespace.
  * `PerNamespaceServerConfiguration` -- A server configuration implementation with support for namespaces.
  * `NamespacedFeedConfiguration` -- A feed configuration implementation with support for namespaces.
  * `NamespacedAdapterConfiguration` -- An adapter configuration implementation with support for namespaces.


---

# Wrapper Manager and ACL Validation #

The Google Feed Server implementation differs in the data adapter layer. The Feed Server provides a `WrapperManager` to wrap target adapters. The `FeedServerProvider` is the provider as well as the workspace manager. The Feed Server always returns a wrapper manager instance instead of the target provider.

The wrapper manager instance is configured with the adapter that you specify as part of the adapter configuration. The wrapper manager instance is configured with the adapter specified as part of adapter configuration as the target adapter. The target adapter will interact with the datasource along with zero or more wrappers. For Abdera, the wrapper manager returned by `FeedServerProvider`, is set as the target adapter. Any CRUD request is passed to the wrapper manager, which performs custom actions like ACL validation. On successful ACL validation, the wrapper manager forwards the request to the target adapter.

To implement a wrapper manager, you need to extend `AbstractWrapperManager`. The target adapter that interacts with a data source should extend `AbstractManagedCollectionAdapter`. The `IBatisCollectionAdapter` is the same adapter implementation from Abdera with the difference that the adapter extends `AbstractManagedCollectionAdapter` so that the adapter can be used as the target adapter with a wrapper manager. The `XMLWrapper` is the wrapper manager implementation provided with the Feed Server.

Wrappers can be configured with the adapter configuration as mixins which store the wrapper configuration. The `mixins` attribute in the adapter configuration points to the wrapper configurations.

```
   mixins=@WRAPPER_1
```

For applying multiple wrappers
```
   mixins=@WRAPPER_1,@WRAPPER_2,@WRAPPER_3
```


---

# Adapters and Wrappers #

  * Adapters are implementations which interact with the datasource to pull the information and construct feeds.
  * Wrappers are implementations which allow pre-processing of request OR post processing of the feed response with request data.

Wrappers are a handy way to plug-in any custom behavior without the target adapter having any knowledge about it. Also, since applying wrappers is done as part of adapter configuration, it is easier to control the wrappers that can be applied at runtime. All wrappers should extend `ManagedCollectionAdapterWrapper`. Since wrappers are essentially adapters, these could also be set as the target adapter in adapter configuration. In such cases the final target adapter defines using the wrapper config as adapter config value that has the knowledge of the target adapter. This is helpful when a feed needs to be wrapped inside another feed.

## Mixins - Applying Wrappers ##

Mixins are a way to define wrapper configurations with adapter configurations. Mixins can be defined as part of adapter configurations and target adapters as well. The mixins defined as part of target adapters are known as implicit mixins since the adapter is aware of the wrappers. This implies that the adapter implementation might be tightly coupled with the warpper as it expect certain things to be handled by the wrapper. By defining the mixins as part of adapter configurations achieves loose coupling since the adapter have no knowledge about any wrapper being applied.

### Defining Mixins with Adapter Configurations ###
The general way of defining a wrapper is as follows:

```
   <?xml version="1.0" encoding="UTF-8" ?>
   <mixin>
     <wrapperName>IBatisAdapterWrapper</wrapperName>
     <wrapperConfig></wrapperConfig>
   </mixin>
```

The wrapper name is actually the name of the adapter (remember wrapper is also an adapter)  stored under `<<namespace>>/<<feedname>>/Adapter`. The wrapper config can be any data that the wrapper requires for pre-processing or post processing. The actual wrapper adapter definition will look something like this:

```
   className=com.google.feedserver.samples.wrappers.IBatisAdapterWrapper
   configValue=""
   configType=XML
   isWrapper=true
```

Where:
  * `className`. The fully-qualified class name of the wrapper.
  * `isWrapper`. The attribute identifies if the adapter is a wrapper or simply an adapter.

You can also define a wrapper configuration as follows:

```
   <?xml version="1.0" encoding="UTF-8" ?>
   <mixin>
     <adapterName>testAdapterWithWrapper</adapterName>
     <wrapperConfig>zxcvzxcv</wrapperConfig>
   </mixin>
```

Where:
  * `adapterName` points to a adapter configuration that contains the details of the target adapter.

The wrapper name is set to the target adapter in the original adapter configuration that uses the wrapper configuration. In this way, you can configure wrappers and adapters to embed a feed under another feed.

The `testAdapterWithWrapper` adapter configuration:

```
   type=SampleBasicAdapter
   configValue=<a>Adapter Config</a>
   configValueType=xml
```

The <b>SampleBasicAdapter</b> is the target adapter over which the wrapper is applied. You can configure additional wrappers as needed.

### Defining Implicit Mixins with Adapters ###
The adapters can define and use implicit mixins as pointers to adapters:

```
   className=com.google.feedserver.samples.adapters.IBatisCollectionAdapter
   implicitMixins=@IBatisAdapterWrapper
   isWrapper=false
```

You can configure implicit mixins for adapters and not wrappers by setting `isWrapper=false`.


---

# Feed Config Store #

To provide loose coupling between the feed and adapter configuration, the framework implements the concept of a feed config store. The main job of a feed config store is to read the feed and adapter configurations and pass the necessary configuration details to the framework so that the framework can initialize the target adapter. The target adapter then interacts with a data source for its CRUD operations. Using this approach, multiple feeds can be configured with the same adapter configuration (and hence same adapter). The feed config store acts as a link between the `FeedServerConfiguration` and the `CollectionAdapterConfiguration`. The feed config store is supposed to understand and support namespaces.

The Feed Server provides a sample file system based feed config store: `SampleFileSystemFeedConfigStore`.
This implementation reads and updates the feed and adapter configurations using property files that are stored on the file system.

Store the feed configuration:
```
/conf/feedserver/{namepsace}/FeedConfig/<<feedId>>.properties
```

Store the adapter configuration:
```
/conf/feedserver/{namepsace}/AdapterConfig/<<adapterName>>.properties
```

Store the adapter details. The <i>feedid</i>.properties has the link to the adapter configuration that should be used to initialize the adapter (defined in Adapter/<i>adapter</i>.properties) and interact with the datasource for CRUD operations.

```
/conf/feedserver/{namepsace}/Adapter/<<adapter>>.properties 
```

Store the wrapper configurations used by adapter configurations:
```
/conf/feedserver/{namepsace}/AdapterConfig/<<mixinName>>.xml 
```

In the earlier release of the Google Feed Server, both the feed and adapter configuration were stored as part of single configuration and were read by the `AdapterManager`.

<b>Note:</b> You can have an implementation with just `FeedConfig` and `AdapterConfig`, but you lose the flexibility of using wrappers.


---

# Signed Requests Support #

The Google Feed Server handles signed requests using
[Google ClientLogin](http://code.google.com/apis/gdata/auth.html#ClientLogin) and
[OAuth](http://code.google.com/apis/accounts/docs/OAuth.html).

## Signed Requests Using Google ClientLogin ##

Use the Google ClientLogin for clients such as a standalone single-user "installed" application (for example, a desktop application). The Google Feed Server ships with the `GetAuthTokenServlet` servlet that authenticates a user and issues authorization tokens to be used with requests for authorization. The `SignedRequestFilter` filter validates each request to check if the request is signed with a valid authorization token.

The token generation and validation of authorization is handled by the `TokenManager`. The sample implementation of `TokenManager: SampleTokenManager` generates tokens without performing authentication and validates the `authz` request token with a token issued earlier for the given user name and service pair. You can test this implementation using the scripts provided under `tests/client/demo`.
For a more robust authentication and authorization mechanism, you can plug in a custom implementation of the `TokenManager`.

## Signed Requests Using OAuth ##

OAuth signed requests are authorized by the `OAuthFilter`. The key assumes Google as the default service provider with a Google public key. The easiest way to test this is to write a OAuth gadget. See http://code.google.com/apis/gadgets/docs/oauth.html. You can plug in a domain-specific key with the `SimpleKeyMananger` without changing OAuth signed requests.


---

# Google Client Library Support #

Developers can use the core aspects of the [Google Data APIs Client Libraries](http://code.google.com/apis/gdata/clientlibs.html) with the Google Feed Server. One example of this is the , [JavaScript client library](http://code.google.com/apis/gdata/client-js.html). Because browsers can submit GET and POST requests, but are unable to issue PUT and DELETE requests, the Feed Server includes a method override filter. The JavaScript library sends a DELETE over a POST request, which the server interprets as a DELETE.

The Google client libraries also have an optional XD2 filter to support cross-domain access.

Many of the higher level functions of the Google Data API client libraries such as for calendar entries, were designed to work specifically with the services on Google.com. Therefore, not all such services are emulated in [google-feedserver](http://code.google.com/p/google-feedserver/).

---

# Work Flow #

This section provides a high-level overview and walk through of the code base.

Supported URL patterns:
  1. http://host:port/«namespace»/«feedname» for feeds
  1. http://host:port/«namespace»/«feedname»/«entryId» for entries

## Manager Package ##

Package `com.google.feedserver.manager` contains the Abdera-based server code:

  * `FeedServerProvider` contains server code that acts as the `Provider` and `WorkspaceManager`.
  * `FeedServerAdapterManager` contains an implementation to create instances of wrapper manager and target adapter by reading the adapter configuration.
  * `FeedServerWorkspace` contains the implementation for `WorkspaceInfo`.
  * `AbstractWrapperManager` has the base implementation for wrapper managers with support for ACL validation.

## Wrappers Package ##

Package `com.google.feedserver.wrappers` contains a base implementation for use by wrappers:

  * `ManagedCollectionAdapterWrapper` contains base implementation for wrappers.

## Configuration Package ##

Package `com.google.feedserver.config` contains implementations for configurations.

  * `FeedServerConfiguration` contains the implementation to get all the configuration  details for the feed server. The implementation is configured with the feed config store.
  * `PerNamespaceServerConfiguration` contains the server configuration implementation with support for a namespace. The implementation uses the `FeedServerConfiguration` internally to load the feed and adapter configurations that are used by `FeedServerAdapterManager` and `FeedServerProvider`.
  * `NamespacedFeedConfiguration` contains the feed configuration implementation with support for a namespace.
  * `NamespacedAdapterConfiguration` contains the adapter configuration implementation with support for namespace.

## Configuration Storage Package ##

Package `com.google.feedserver.configstore` contains the `FeedConfigStore` interface that defines supported operations for reading and storing the feed and adapter configurations.

## Adapter Package ##

Package `com.google.feedserver.adapter` contains the code required to define base implementations to build new adapters.  This package handles all data aspects of the Feed Server:
  * `AbstractManagedCollectionAdapter` contains the base adapter implementation. Developers should check the functionality provided here before defining new adapter implementations.

## Metadata Package ##

Package `com.google.feedserver.config.metadata` contains implementations related to metadata.

## Servlet Package ##

Package `com.google.feedserver.server.servlet` contains servlet implementations:

  * `GetAuthTokenServlet` contains implementation to authenticate and generate authorization tokens for clients using Google ClientLogin. This implementation uses the `TokenManager`.
  * `MethodOverridableRequest` is a `HttpServletRequestWrapper` that returns the HTTP method when the request has the `X-HTTP-Method-Override` header set. This is required when a firewall does not allow PUT. The request is then sent as an HTTP POST with the method override header set as `PUT`.
  * `MethodOverrideServletFilter` allows the `X-HTTP-Method-Override` value to be returned as the HTTP method.
  * `FeedServerInitializationServlet` contains an implementation that initializes the Feed Server when running on Apache Tomcat.

## Filters Package ##

Package `com.google.feedserver.filters` contains the filters to handle signed requests:

  * `OAuthFilter` contains an implementation to check if the request is signed with OAuth authorization parameters.
  * `SignedRequestFilter` contains the implementation to check if the request is signed with authz token issued to the user earlier as part of Google ClientLogin. It uses the `TokenManager` for the same.

## Authentication Package ##

Package `com.google.feedserver.authentication` contains implementations for handling authentication and authorization:

  * `TokenManager` defines the operations for handling authentication and authorization for each request.
  * `TokenManagerDIModule` is the Google Guice module that configures a concrete `TokenManager` instance.  You can plug in custom `TokenManager` implementations in this module.
  * `SampleTokenManager` contains the sample implementation for `TokenManager`.

## Samples Package ##

Package `com.google.feedserver.samples.*`
  * Contains the sample implementations of an adapter, wrapper manager, wrappers, feed config store and an ACL validator.

## Jetty Package ##

Package `com.google.feedserver.server.jetty`:

  * Run time main class that starts the application on the Jetty server.

## Tools Package ##

Package `com.google.feedserver.tools` and `com.google.feedserver.client` contains the client classes to work with the Feed Server:

  * `FeedServerClientTool` is a command line client implementation for the CRUD operations.


---

# Request Flow #

Incoming Request:

===>> to `AbderaServlet`
> ===>> to `AbstractProvider`
> > ===>> to `FeedServerProvider`
> > > ===>> to `FeedServerAdapterManager`
> > > > ===>> to `SampleFileSystemFeedConfigStore`
> > > > > ===>> to `XMLWrapperManager`
> > > > > > ===>> to `IBatisAdapterWrapper`
> > > > > > > ===>> to `IBatisCollectionAdapter`