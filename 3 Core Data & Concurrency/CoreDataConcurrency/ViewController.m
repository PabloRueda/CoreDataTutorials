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

@interface ViewController ()
- (void)importEmployees;
- (void)loadAndShowAllEmployees;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self importEmployees];
}

#pragma mark - Private Imp

- (void)importEmployees {
    
    NSManagedObjectContext *privateContext = [self.store createPrivateContext];
    
    [privateContext performBlock:^() {
    
        //We create all the employees in the background using our context, and after we save it
        int count = 10000;
        for (int i = 0; i < count; i++) {
            Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:privateContext];
            employee.initials = [NSString stringWithFormat:@"%d", i];
            employee.name = [NSString stringWithFormat:@"name %d", i];
        };
        
        [privateContext save:nil];
        
        [self loadAndShowAllEmployees];
    }];
}

- (void)loadAndShowAllEmployees {
    NSManagedObjectContext *context = self.store.mainManagedObjectContext;
    [context performBlockAndWait:^(){
        
        //We make the request to obtain all the employees in the main context because we will use them in the main thread (to refresh the UI)
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        _employeesToShow = [context executeFetchRequest:fetchRequest error:nil];
        
        //We can update our table
        [self.tableView reloadData];
    }];
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
    
    Employee *employee = [_employeesToShow objectAtIndex:indexPath.row];
    cell.textLabel.text = employee.name;
    cell.detailTextLabel.text = employee.initials;
    
    return cell;
}

@end
