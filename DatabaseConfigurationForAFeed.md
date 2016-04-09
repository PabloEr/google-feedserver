<h1>Database Configuration for a Feed</h1>

This document describes how to create a feed configuration, adpater configuration and configure database settings.

---

<h2>Contents</h2>


---


# Creating a Mapping File in iBATIS Format #

In the `conf/feedserver/sqlmap/` folder, create a mapping file for iBATIS to map Java objects to database queries and results on the table and view.

For example: `contact.xml` mapping file:

```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE sqlMap
    PUBLIC "-//ibatis.apache.org//DTD SQL Map 2.0//EN"
    "http://ibatis.apache.org/dtd/sql-map-2.dtd">

<sqlMap namespace="test">
  <resultMap id="result-map" class="java.util.HashMap">
    <result property="id" column="id"/>
     <result property="firstName" column="first_name"/>
     <result property="lastName" column="last_name"/>
    <result property="email" column="email"/>
    <result property="rating" column="rating"/>
  </resultMap>

  <select id="contact-get-feed" resultMap="result-map">
    select * from Contact
  </select>
 
  <select id="contact-get-entry" resultMap="result-map">
    select * from Contact where id = #value#
  </select>

  <delete id="contact-delete-entry" >
    delete from Contact where id = #value#
  </delete>
 
  <insert id="contact-insert-entry" parameterClass="map">
    insert into Contact (first_name,last_name,email,rating) values
        (#firstName#,#lastName#,#email#,#rating:NUMERIC#)
     <selectKey keyProperty="id" resultClass="long">
      <!-- For MySQL:   SELECT LAST_INSERT_ID()-->
      <!-- For Derby: --> values IDENTITY_VAL_LOCAL()
      <!-- For PostGRE SQL: SELECT currval('"contact_id_seq"')  -->
    </selectKey>
  </insert>

  <update id="contact-update-entry" parameterClass="map">
    update Contact set last_name = #lastName#, first_name = #firstName#,
        email = #email#, rating = #rating:NUMERIC# where id = #id#
  </update>
</sqlMap>
```

<b>Note</b>: All the `id` attributes in the previous XML file use the following naming conventions:

  * To get a feed, id=`<feedname>`-get-feed
  * To get an entry, id=`<feedname>`-get-entry
  * To insert an entry, id=`<feedname>`-insert-entry
  * To delete an entry, id=`<feedname>`-delete-entry
  * To update an entry, id=`<feedname>`-update-entry

The name of the file should be `<feedname>` for easy mapping and understanding.

---

# Creating an XML File with Database Connection Parameters for iBATIS #
The following example creates the `sqlmap.xml` file:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE sqlMapConfig     
    PUBLIC "-//ibatis.apache.org//DTD SQL Map Config 2.0//EN"     
    "http://ibatis.apache.org/dtd/sql-map-config-2.dtd">
<sqlMapConfig>
  <properties resource="database/dbConfig.properties"/>

  <typeHandler javaType="string" jdbcType="NUMERIC"
      callback="com.google.feedserver.ibatisCallbackHandlers.StringToNumericCallback" />

  <!-- Configure a built-in transaction manager.  If you're using an
       app server, you probably want to use its transaction manager
       and a managed datasource -->
  <transactionManager type="JDBC" commitRequired="false">
   
    <dataSource type="SIMPLE">
      <property name="JDBC.Driver" value="${JDBC.Driver}"/>
      <property name="JDBC.ConnectionURL" value="${JDBC.ConnectionURL}"/>
      <property name="JDBC.Username" value="${JDBC.Username}"/>
      <property name="JDBC.Password" value="${JDBC.Password}"/>
      <property name="Pool.MaximumActiveConnections" value="${Pool.MaximumActiveConnections}"/>
      <property name="Pool.MaximumIdleConnections" value="${Pool.MaximumIdleConnections}"/>
      <property name="Pool.MaximumCheckoutTime" value="${Pool.MaximumCheckoutTime}"/>
      <property name="Pool.TimeToWait" value="${Pool.TimeToWait}"/>
    </dataSource>
  </transactionManager>

</sqlMapConfig>
```

The `database/dbConfig.properties` file contains the actual values, which are also used by the Ant build script to create the database.

The reference to `contact.xml` is inserted by the wrapper at runtime as shown below:
```
<sqlMap resource="feedserver/sqlmap/contact.xml"/>
```

The value `sqlmap/contact.xml` is specified as part of feed configuration as explained in the following sections.

# Creating an Adapter Properties File #

Create an adapter properties file in `conf/feedserver/{namespace}/Adapter/` dir.

For example: `IBatisAdapter.properties`

```
   className=com.google.feedserver.samples.adapters.IBatisCollectionAdapter
   isWrapper=false

   className is the fully qualified name of the adapter class that will interact with the datasource to perform CRUD operations
   isWrapper indicates whether the given adapter is a wrapper or simply an adapter
```

---

# Creating an Adapter Configuration Properties File #
Create an adapter configuration properties file in the `conf/feedserver/{namespace}/AdapterConfig/` folder.

For example: `jdbcAdapterConfig.properties`

```
   type=IBatisAdapter
   configValueType=xml
   configValue=@sqlmap.xml
   mixins=@IBatisAdapterWrapper
```

Attributes:
  * `type` indicates the name of the target adapter stored under `conf/feedserver/{namespace}/Adapter/` directory

  * `configValueType` indicates the kind of content value that will be specified as `configValue`

  * `configValue` is the configuration value used by the adapter class to interact with the datasource.
> The content type (xml, text, etc) should be as specified by 'configValueType'.

> If the value starts with '@', it implies that the value following '@' should be treated
> as the name of the file whose contents will be treated as configValue.
> The feed config store will have the responsibility of reading the
> file contents and setting them as the config value while loading the
> adapter config values.

  * `mixins` is a pointer to the wrapper configurations to be applied over the target adapter

---

# Creating a Wrapper Config #
Create an XML file under `conf/feedserver/{namespace}/AdapterConfig/` directory

For example: `IBatisAdapterWrapper.xml`

```
   <?xml version="1.0" encoding="UTF-8"?>
   <mixin>
      <wrapperName>IBatisAdapterWrapper</wrapperName>
      <wrapperConfig></wrapperConfig>
   </mixin>
```

Attributes:

  * `wrapperName` is the pointer to wrapper stored under `conf/feedserver/{namespace}/Adapter/` directory

  * `wrapperConfig` is any data that the wrapper will use

Create a `IBatisAdapterWrapper.properties` under `conf/feedserver/{namespace}/Adapter/` directory having the wrapper details.

```
   className=com.google.feedserver.wrappers.IBatisAdapterWrapper
   configValue=""
   configType=XML
   isWrapper=true
```

Attributes:

  * `className` is the fully qualified name of the wrapper class

  * `isWrapper=true` identifies this adapter as wrapper


---

# Creating a Feed Properties File #
Create a feed properties file in `conf/feedserver/{namespace}/FeedConfig/` folder.

For example: `contact.properties`

```
   subUri=contact
   title=feed
   author=FeedServer
   adapterName=jdbcAdapterConfig
   configValue=@sqlmap/contact.xml
```

Attributes:

  * `adapterName` is the name of the adapter configuration file.
> This attribute acts as the link between the feed and adapter configurations.

> The feed config store loads adapter values automatically for the specified adapter name while loading the feed configuration values.

  * `configValue` is the value specific to the feed but will part of the adapter `configValue`.
> If a value starts with '@',  the value after '@' is the name of the file. The feed config store either adds the contents of file to the adapter 'configValue' or adds the name of the file.