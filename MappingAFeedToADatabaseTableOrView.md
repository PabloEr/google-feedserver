<h1>How to Map a Feed to a Database Table or View</h1>

---

<h2>Contents</h2>



---

# Configuring a Mapping File in iBATIS Format #
In the `conf/feedserver/sqlmap/` folder, create a mapping file for iBATIS to map Java objects to database queries and results for a table or view.

For example:
```
<?xml version="1.0" encoding="UTF-8" ?>

<!DOCTYPE sqlMap
    PUBLIC "-//ibatis.apache.org//DTD SQL Map 2.0//EN"
    "http://ibatis.apache.org/dtd/sql-map-2.dtd">

<sqlMap namespace="compplanning_demo">

  <resultMap id="result-perfinfo" class="java.util.HashMap">
    <result property="id" column="PerfInfoId"/>
    <result property="JobTitle" column="JobTitle"/>
    <result property="JobGrade" column="JobGrade"/>
    <result property="JobCode" column="JobCode"/>
    <result property="EmployeeId" column="EmployeeId"/>
    <result property="title" column="title"/>
  </resultMap>

  <select id="perfinfo-get-feed" resultMap="result-perfinfo">
    SELECT a.*, b.Username as "title"
    FROM PerfInfo a,Employee b
    WHERE PerfInfoId  &lt; 100
       AND a.EmployeeId = b.EmployeeId
  </select>

  <select id="perfinfo-get-entry" resultMap="result-perfinfo">
     SELECT a.*, b.Username as "title"
        FROM PerfInfo a,Employee b
        WHERE PerfInfoId  = #id#
       AND a.EmployeeId = b.EmployeeId
  </select>

  <delete id="perfinfo-delete-entry" >
    delete from PerfInfo where PerfInfoId = #value#
  </delete>

  <insert id="perfinfo-insert-entry" parameterClass="map">
    insert into PerfInfo (JobTitle, JobGrade, JobCode, EmployeeId) values
        (#JobTitle#, #JobGrade#, #JobCode#, #EmployeeId#)
   <selectKey keyProperty="id" resultClass="int">
     SELECT last_insert_id()
   </selectKey>
  </insert>

</sqlMap>

```

**Note**: The `id=` attributes in the previous XML example have the following naming conventions:
  * Id of getFeed query: `<feedname>-get-feed`
  * Id of getEntry query: `<feedname>-get-entry`
  * Id of insertEntry query: `<feedname>-insert-entry`
  * Id of deleteEntry query: `<feedname>-delete-entry`
  * Id of updateEntry query: `<feedname>-update-entry`

---

# Configuring an XML File with Database Connection Parameters #

Set up an XML file with database connection parameters.

For example:
```
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE sqlMapConfig
      PUBLIC "-//ibatis.apache.org//DTD SQL Map Config 2.0//EN"
      "http://ibatis.apache.org/dtd/sql-map-config-2.dtd">

   <sqlMapConfig>
     <transactionManager type="JDBC" commitRequired="false">
      <dataSource type="SIMPLE">
        <property name="JDBC.Driver" value="com.mysql.jdbc.Driver"/>
        <property name="JDBC.ConnectionURL" value="jdbc:mysql://host:port/dbname"/>
        <property name="JDBC.Username" value="username"/>
        <property name="JDBC.Password" value="password"/>
     </dataSource>
    </transactionManager>
   <sqlMap resource="feedserver/sqlmap/the_above_xml_filename"/>

  </sqlMapConfig>
```


---

# Configuring an Adapter Properties File #
Create an adapter properties file in the `conf/feedserver/adapter/` folder.

For example:
```
   subUri=<feedname>
   adapterClassName=com.google.feedserver.adapter.JdbcAdapter
   configFile=<the above xml filename with database connection params>
   title=PerfInfo Feed
   author=QA team
```