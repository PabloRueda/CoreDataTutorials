The important thing to know, though, is that it’s not a database. It’s an object graph and persistence manager.

Core Data can serialize objects into XML, Binary, or SQLite for storage.[2] With the release of Mac OS X 10.5 Leopard, developers can also create their own custom atomic store types.

Core Data actually operates over a different domain to SQLite — meaning that it provides lots of services that SQLite doesn't but also that Core Data can't provide some of the services that SQLite can. Even for services that both technologies provide, there are different performance considerations.

SQLite and many other relational databases don't handle the mechanics of connecting objects; maintaining state (like a an object relation) between columns, rows or tables is left to the user of the database.

Core Data is a framework that takes care of your data model, provides consistency mechanisms and deals with the file system/dbms to store data.

### Primary function of a database:

1 persistent and searchable storage for data in table, row, column format where the primary goal is to keep the data up-to-date on disk at all times

2 powerful, focussed, narrow fetching and updating capabilities

### Things Core data can do (Primary function of Core Data):

1 You can connect object A to object B and the connection at both the A and B ends is kept perpetually in sync.

2 If you change the connection at the A end, the B end will be updated and all changes trigger notifications (to which you can attach arbitrary code)

3 Deletion of objects at one end of a connection can trigger cascading deletion or nullify responses.

4 The other end of a connection can exist out of memory (faulted) unless the connection is actually followed at which time the connected object is loaded.

5 Core Data can be used totally in-memory

6 it is possible to use Core Data without any form of searching. If you allocate and connect all your objects, all you need to do is hold onto one of them and you can walk through everything without needing a fetch request

7 Properties and behaviors (of core data objets) are implemented by methods, making them both observable and overrideable.

### Common database tasks that Core Data doesn't do

1 Core Data cannot operate on data without loading the data into memory, even to delete an object

2 Core Data does not handle data logic, data attributes are all the responsibility of the business logic in the rest of the program, a good example being "unique" keys in sql.

3 Core Data does not offer any amount of threading support. If you need another thread working on the same data, you need to save the file and reopen using a different NSManagedObjectContext in the other thread

### When use SQL?

1 It's critical the Actions that Cut Across Large Numbers of Objects

2 It's critical the  Typical mark all as read. Need update 1 parameter in a large number of objets 

3 You are going to port the code to other platforms

### When use Core Data:

The rest of the time, that is practically the 95%

### Benifts of using Core Data:

1 If your application fits nicely into this architecture (MVC), it's probably worth using Core Data as it will save you a lot of code in the model component. 

2 Handle for you memory management, etc

3 High level of abstraction of your database

4 Core Data will handle versioning of your data model

5 KVO

6 iCloud file-sync for free

7 better integration with the rest of the Cocoa API

8 Core Data graphical user interface editor