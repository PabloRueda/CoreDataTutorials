# Core Data or SQLite

## Summary
1. Differences between Core Data and SQLite
2. Primary use of a DataBase
3. Primary use of an Object Graph
4. What Core Data can do
5. What Core Data can’t do
6. When to use SQLite?
7. When to use Core Data?
8. Benefits of using Core Data
9. Examples of queries and CoreData similar use
10. References

## 1 Differences between Core Data and SQLite

- SQLite is a database
- Core Data is an object graph and persistence manager
- Core Data can store objects into XML, SQLite, atomic or in-memory
- There are things that SQLite can do, but not Core Data. Example: Unique ids
- And viceversa. Example: See the relationships of an object

## 2 Primary use of a DataBase

- Persistant storage
- Fetching and updating capabilities

## 3 Primary use of an Object Graph

- View the instances of a system and their relationships at a particular point in time

## 4 What Core Data can do

- Retrieve and manipulate data without worrying about the details of storage or retrieval
- When you connect 2 objects they are perpetually in sync
- Connected objects can exist out of memory (faulted) until they are needed
- Deletion of objects can trigger cascading deletion
- Can be used totally in-memory
- It’s possible to use Core Data without any form of searching if your objects are all connected
- Properties are implemented by methods and they are observables and overrideables

## 5 What Core Data can’t do

- Core Data must load the data into memory to operate, even to delete an object
- Core Data doesn’t handle data logic, it’s responsibility of the business logic. Example: unique ids in SQL
- Doesn’t support multiple threading access

## 6 When to use SQLite?

- The action where you delete a large number of objects it’s critical in your system
- The action where you update with the same value a large number of objects it’s critical in your system. Example: mark all as read
- You are going to port the code to other platforms

## 7 When to use Core Data?

- The rest of the time, that is practically the 95% of the time

## 8 Benefits of using Core Data 

- It saves a lot of code in the model component
- High level of abstraction of your database
- Better integration with the rest of the Cocoa API
- It handles for you memory management
- It handles versioning of your data model
- KVO
- iCloud file sync for free
- Core Data graphical user interface editor

## 9 Examples of queries and CoreData similar use

Employee with initials ‘PR’

	SELECT * FROM employees WHERE initials = ’PR’
	
	[entity setName:@"Employee"];
	[NSPredicate predicateWithFormat:@"initials == ‘PR’"];

Employees that have the account with id ‘MNS002’

	SELECT employees.* FROM employees JOIN employees_accounts ON employees_accounts.employee_id = employees.initials WHERE account_id = ‘MNS002’
    
	[entity setName:@"Employee"];
	[NSPredicate predicateWithFormat:@"accounts.id CONTAINS ‘MNS002’"];


Number of accounts where there is the employee with initials ‘PR’

	COUNT (*) FROM employees_accounts WHERE employee_id = ‘PR’
    
	[entity setName:@"Employee"];
	[NSPredicate predicateWithFormat:@"initials == PR"];
	employee.accounts.count;
    
	[entity setName:@"Employee"];
	[NSPredicate predicateWithFormat:@"initials == PR"];
	NSExpression *keyExp = [NSExpression expressionForKeyPath:@"accounts.code"];
	[NSExpression expressionForFunction:@"count:" arguments:@[keyExp]];

## 10 References

- https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/cdProgrammingGuide.html
- http://www.cocoawithlove.com/2010/02/differences-between-core-data-and.html
- http://stackoverflow.com/questions/840634/core-data-vs-sqlite-for-sql-experienced-developers
- http://en.wikipedia.org/wiki/Core_Data
- https://github.com/PabloRueda/CoreDataTutorials
