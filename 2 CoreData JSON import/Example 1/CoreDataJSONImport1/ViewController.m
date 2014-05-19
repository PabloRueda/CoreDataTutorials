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
- (NSArray*)allEmployees;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadEmployeesJSON];
    
    _employeesToShow = [self allEmployees];
}

#pragma mark - Private Imp

- (void)loadEmployeesJSON {
    NSManagedObjectContext *context = self.store.managedObjectContext;
    
    //We open a file with our JSON, as a simulation of a service call result
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Employees" ofType:@"json"];
    NSArray *employeesJSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    
    NSMutableDictionary *accountsDictionary = [NSMutableDictionary dictionary];
    
    //We iterate trough each element of our json to create the employees
    [employeesJSON enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
        employee.initials = [obj objectForKey:@"initials"];
        employee.name = [obj objectForKey:@"name"];
        
        NSMutableSet *accounts = [NSMutableSet set];
        NSArray *accountsJSON = [obj objectForKey:@"accounts"];
        
        //We iterate trough each account of the current employee, caching the accounts to don't recreate them
        [accountsJSON enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            
            NSString *code = [obj objectForKey:@"code"];
            Account *account = [accountsDictionary objectForKey:code];
            if (!account) {
                account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
                account.code = code;
                account.name = [obj objectForKey:@"name"];
                
                [accountsDictionary setObject:account forKey:account.code];
            }
            
            [accounts addObject:account];
        }];
        
        employee.accounts = accounts;
        
    }];
    
    //We save at the end of the import, not in each step
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
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
