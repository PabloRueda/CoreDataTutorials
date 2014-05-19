//
//  ViewController.m
//  Copyright (C) 2014 Pablo Rueda
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "ViewController.h"
#import "Employee.h"
#import "Account.h"
#import "AppDelegate.h"


@interface ViewController ()
- (void)loadEmployeesJSON;
- (void)loadAccountsJSON;
- (NSArray*)allEmployees;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadEmployeesJSON];
    
    [self loadAccountsJSON];
    
    _employeesToShow = [self allEmployees];
}

#pragma mark - Private Imp

- (void)loadEmployeesJSON {
    NSManagedObjectContext *context = self.store.managedObjectContext;
    
    //We open a file with our JSON, as a simulation of a service call result
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Employees" ofType:@"json"];
    NSArray *employeesJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    
    _cachedEmployees = [NSMutableDictionary dictionary];
    
    //We iterate trough each element of our json to create the employees (and caching them) without the accounts
    [employeesJSON enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
        employee.initials = [obj objectForKey:@"initials"];
        employee.name = [obj objectForKey:@"name"];
        
        [_cachedEmployees setObject:employee forKey:employee.initials];
    }];
    
    //We save at the end of the import, not in each step
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //If the memory consumption is high we should fault our employees
    for (Employee *employee in [_cachedEmployees allValues]) {
        [context refreshObject:employee mergeChanges:NO];
    }
}

- (void)loadAccountsJSON {
    NSManagedObjectContext *context = self.store.managedObjectContext;
    
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Accounts" ofType:@"json"];
    NSArray *accounts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    
    [accounts enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        Account *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
        account.code = [obj objectForKey:@"code"];
        account.name = [obj objectForKey:@"name"];
        
        //We can make the relationship with our cached employees
        account.employees = [self accountsForEmployees:[obj objectForKey:@"employees"]];
        
        //Wrong way of obtaining the accounts:
        //account.employees = [self badPerformanceAccountsForEmployees:[obj objectForKey:@"employees"]];
    }];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //Remember to delete the cached employees or it will consume memory
    _cachedEmployees = nil;
}

- (NSSet*)accountsForEmployees:(NSArray*)initialsArray {
    NSMutableSet *accounts = [NSMutableSet set];;
    for (NSString *initials in initialsArray) {
        [accounts addObject:[_cachedEmployees objectForKey:initials]];
    }
    return accounts;
}

- (NSSet*)badPerformanceAccountsForEmployees:(NSArray*)initialsArray {
    NSManagedObjectContext *context = self.store.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"initials IN %@", initialsArray]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    return [NSSet setWithArray:fetchedObjects];
}

- (NSArray*)allEmployees {
    NSManagedObjectContext *context = self.store.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _employeesToShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Employee *employee = [_employeesToShow objectAtIndex:indexPath.row];
    cell.textLabel.text = employee.name;
    NSMutableString *accounts = [NSMutableString string];
    for (Account *account in employee.accounts) {
        [accounts appendString:account.name];
    }
    cell.detailTextLabel.text = accounts;
}

@end
