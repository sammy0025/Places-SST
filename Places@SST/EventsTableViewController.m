//
//  EventsTableViewController.m
//  Places@SST
//
//  Created by Pan Ziyue on 24/12/14.
//  Copyright (c) 2014 StatiX Industries. All rights reserved.
//

#import "EventsTableViewController.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"

@interface EventsTableViewController (){
    NSXMLParser *parser;
    
    NSMutableArray *feeds; //Main feeds array
    
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *date;
    NSMutableString *author;
    NSString *element;
    
    NSArray *searchResults;
}

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Init refresh controls
    UIRefreshControl *refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD showWithStatus:@"Loading feeds..." maskType:SVProgressHUDMaskTypeBlack];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            feeds = [[NSMutableArray alloc] init];
            
            NSString *combined=[NSString stringWithFormat:@"http://studentsblog.sst.edu.sg/feeds/posts/default?alt=rss"];
            //NSString *combined = [NSString stringWithFormat:@"https://api.statixind.net/cache/blogrss.xml"];
            
            NSURL *url = [NSURL URLWithString:combined];
            parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            if (!title){
                [SVProgressHUD showErrorWithStatus:@"Check your Internet Connection"];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        });
    });
}

-(void)refresh:(id)sender
{
    //Async refreshing
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self.tableView reloadData];
        feeds = [[NSMutableArray alloc] init];
        self.tableView.userInteractionEnabled=NO;
        NSString *combined=[NSString stringWithFormat:@"http://studentsblog.sst.edu.sg/feeds/posts/default?alt=rss"];
        //NSString *combined=[NSString stringWithFormat:@"https://api.statixind.net/cache/blogrss.xml"];
        NSURL *url = [NSURL URLWithString:combined];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [(UIRefreshControl *)sender endRefreshing];
            self.tableView.userInteractionEnabled=YES;
        });
    });
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //Checking for if title contains text and then put them in the array for search listings
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.title contains[cd] %@",
                                    searchText];
    
    searchResults = [feeds filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

#pragma mark - Table view data source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    else
    {
        return [feeds count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    } else {
        if (feeds.count!=0) {
            if ([[[feeds objectAtIndex:indexPath.row]objectForKey:@"title"]  isEqual: @""]) {
                cell.textLabel.text = @"<No Title>";
            } else {
                cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
            }
            NSString *detailText = [NSString stringWithFormat:@"%@ %@", [[feeds objectAtIndex:indexPath.row] objectForKey:@"date"], [[feeds objectAtIndex:indexPath.row]objectForKey:@"author"]];
            cell.detailTextLabel.text = detailText;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil) {
        [self performSegueWithIdentifier:@"MasterToDetail" sender:self]; //Perform the segue
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; //Auto deselect tableView
    }
}

#pragma mark - NSXMLParser Delegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict //Parser didStartElement function
{
    element = elementName;
    
    if ([element isEqualToString:@"item"])
    {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        date    = [[NSMutableString alloc] init];
        author  = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName //Parser didEndElement function
{
    if ([elementName isEqualToString:@"item"])
    {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:date forKey:@"date"];
        [item setObject:author forKey:@"author"];
        
        [feeds addObject:[item copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string //Finding elements...
{
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [date appendString:string];
        //This will remove the last string in the date (:00 +0000)
        date = [[date stringByReplacingOccurrencesOfString:@":00 +0000"withString:@""]mutableCopy];
    }
    else if ([element isEqualToString:@"author"]) {
        [author appendString:string];
        author = [[author stringByReplacingOccurrencesOfString:@"noreply@blogger.com " withString:@""]mutableCopy];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser //Basically, did finish loading the whole feed
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData]; //Reload table view data
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError //Errors?
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD showErrorWithStatus:@"Check your Internet Connection"];
    });
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"MasterToDetail"])
    {
        NSIndexPath *indexPath;
        
        if ([self.searchDisplayController isActive])
        {
            indexPath=[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *string = [searchResults[indexPath.row] objectForKey: @"link"];
            [[segue destinationViewController] setReceivedURL:string];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
            [[segue destinationViewController] setReceivedURL:string];
        }
    }
}


@end
