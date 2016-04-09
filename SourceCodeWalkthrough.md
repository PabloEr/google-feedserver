<h1>Source Code Walkthrough</h1>

Provides information about Google Feed Server components, how to build an adapter, Feed Server packages, and the request flow.


---

<h2>Contents</h2>



---

# Overview #

Google Feed Server:

  * Builds a server based on Apache's [Abdera framework](http://abdera.apache.org/docs/api/index.html) to handle the Atom Protocol.
  * Builds an extensible mechanism to convert data from any data source into an Atom feed without having to write code to handle the Atom Protocol details.
  * Separates the two concerns; Builds a server without dependencies between Atom Protocol handling and the mechanism for getting data into or out of the data sources.
  * Makes it easy and quick to add adapters for new data sources.


---

# Google Feed Server Components #

  * Apache Abdera-based Atom Server:
    * Apache Abdera provides a framework to build servers to handle Atom Protocol. Google Feed Server uses the Abdera framework to build an Atom server as a very thin layer of code that uses the Abdera framework to ensure that data into or out of the server satisfies the  Atom Protocol.

  * Data Adapter framework:
    * Adapters interface with the data sources to perform CRUD (Create Retrieve Update Delete) operations on data. For example, a `JdbcAdapter` (included in the distribution) handles the mechanism of data from and into databases. Adapters against any new data sources can be written simply by implementing the `Adapter` interface. Two example implementations are provided with the distribution: `JdbcAdapter` and `SampleAdapter`.


---

# Building an Adapter #

To build an adapter:

  1. Implement the `Adapter` Interface (`Adapter.java`). `SampleAdapter.java` is a reference adapter implementation that you can view while you write the adapter for your particular data source.
  1. Create an adapter properties file in the `conf/feedserver/adapter/` folder. For example, this directory should contain the adapter properties files for `JdbcAdapter` and `SampleAdapter`.
  1. Make sure your adapter class is in the `CLASSPATH`, so that it can be loaded at runtime by the classloader.
  1. `AbstractAdapter.java` contains many of the common methods used by the adapters. This is still an evolving class. Put methods in this class that you find useful for other adapter writers.


---

# Code Structure and a Mini Code Walkthrough #

The sections that follow list important Feed Server packages, the parent folder, and the package contents.

## Server Package ##
The `com.google.feedserver.server` package, which is under `src/java/`, contains:

  * Contains the Abdera-based server code. Currently, this package handles the following URL patterns (specified in `FeedServerTargetResolver.java`)
  * `http://host:port/«feedname»`  for feeds
  * `http://host:port/«feedname»/«entryId»` for entries
  * `FeedServerProvider.java` contains the integral part of the server code. The Feed Server provider is based on the example server code from Abdera.

## Adapter Package ##
The
`com.google.feedserver.adapter` package, which is under `src/java/`, contains
all the code required to define adapter interfaces and common methods, to build new adapters AND two sample adapters. This package handles all data aspects of the Feed Server. This package is the most useful for server developers who write adapters for new data sources:

  * `Adapter.java`. The interface to which all adapters are to be written
  * `AbstractAdapter.java`. The abstract class containing all methods useful for all adapters
  * `AdapterManager.java`. The adapter manager loads the adapter properties file for a given feed and instantiates the class instance to service the specified feed. The adapter properties file is `conf/feedserver/adapter/«feed».properties`.
  * `JdbcAdapter.java`. The adapter to use for a database data source. This adapter looks for the `conf/feedserver/sqlmap.xml` file to load the database specific information, such as the connect string. Within this `sqlmap.xml` file, the adapter also finds references to all table-mapping related XML files used by iBATIS. For example, at the end of the file, you should see the reference to `sqlmap/contact.xml`, which refers to the Contact table in the database and its mappings. All table-mapping XML files should be placed under the `conf/feedserver/sqlmap/` folder.

## Jetty Package ##
The `com.google.feedserver.Jetty` package, which is under `src/java/`, contains the runtime main class to start the application on the Jetty server.

## SQL Map Type Package ##
The `com.google.sqlmap.type` package, which is under `src/java/`, is used by the iBATIS mapping.


---

# Request Flow #
**Incoming Request:**
> ---» To the Abdera servlet.
> > ---» To `com.google.feedserver.server.FeedServerProvider`.
> > > ----» Calls the corresponding adapter in `com.google.feedserver.adapter` to get and put data.