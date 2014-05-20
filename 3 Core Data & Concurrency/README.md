# Core Data Concurrency

There are two possible ways to have concurrency:

1. Create a separate managed object context for each thread and share a single persistent store coordinator.
2. Create a separate managed object context and persistent store coordinator for each thread.

This project uses the first one.

## Architecture

Our Store class has a context in the main queue that we will use to obtain all the objects that we need to draw the GUI, and a method to create contexts that will run in the background, specially for inserting data or for long requests.

We should NOT access an object created from another thread in the current thread. If we modify the same context from two different threads at the same time we can put it into an inconsistent state.

Another things to consider it is that our Store will listen notifications when a private context will save his state, so that we can merge the changes with the main context (useful for example if we are using an NSFetchedResultsController).

## Context types

When we create the context we need to specify the concurrency type we want. It can be:

- ***NSConfinementConcurrencyType***

You promise that context will not be used by any thread other than the one on which you created it. You can use threads, serial operation queues, or dispatch queues for concurrency. For backwards compatibility, not recommended to use.

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        ...
    });

- ***NSMainQueueConcurrencyType*** or ***NSPrivateQueueConcurrencyType***

The context will manage its own queue, and all operations on it need to be performed using ***performBlock**:* or ***performBlockAndWait***:

	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[context performBlock:^() { ... } ];
