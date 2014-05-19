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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self firstQuery];
    
    [self secondQuery];
    
    [self thirdQuery];
}

//Employee with initials ‘PR’
//SELECT * FROM employees WHERE initials = ’PR’
- (void)firstQuery {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"initials == 'PR'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%@", results);
}

//Employees that have the account with id ‘MNS002’
//SELECT employees.* FROM employees JOIN employees_accounts ON employees_accounts.employee_id = employees.initials WHERE account_id = ‘118_00’
- (void)secondQuery {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accounts.code CONTAINS 'MNS002'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%@", results);
}

//Number of accounts where there is the employee with initials ‘PR’
//SELECT COUNT (*) FROM employees_accounts WHERE employee_id = 'PR'
- (void)thirdQuery {
    
    NSExpression *ex = [NSExpression expressionForFunction:@"count:" arguments:@[[NSExpression expressionForKeyPath:@"accounts.code"]]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"result"];
    [expressionDescription setExpression:ex];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"initials == 'PR'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPropertiesToFetch:@[expressionDescription]];
    [request setResultType:NSDictionaryResultType];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSDictionary *resultsDictionary = [results objectAtIndex:0];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    
    NSLog(@"%@", resultValue);
}

@end
