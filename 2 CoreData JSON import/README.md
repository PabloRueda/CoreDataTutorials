# Core Data JSON import

These examples try to explain how to develop an application that makes a service call that responds with a JSON and we need to import that information into our core data store.

We focus in the data import, so the service part it's omitted in this tutorial, we just read the JSON from a plain text file.

There are 2 examples, in the first we have all our data in the same JSON, and in the second the data corresponds to 2 different calls to a service.

## Example 1

The method loadEmployeesJSON simulates the call to a service. There we receive all the employees, and the accounts are part of the employees.

Notice that, as accounts are unique, we need to know which accounts we have created to don't recreate them.

Also notice that we save all our data at the end of the method and not after create every employee, this is important for performance.

## Example 2

Here we have 2 simulations of call services. In the first we load the employees and we store them temporaly into a dictionary to permit to access them later without the need to request them to Core Data.

In the second we load the accounts and we make the relationships with the employees.

Instead of caching the employees a person could think to request the employees to Core Data in every step where we create the account. This is very bad for performance reasons and we should avoid it.