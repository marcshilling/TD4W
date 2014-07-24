//
//  TD4WTranslationViewController.m
//  TD4WButton
//
//  Created by Marc Shilling on 7/24/14.
//  Copyright (c) 2014 JM Apps. All rights reserved.
//

#import "TD4WTranslationViewController.h"
#import "TD4WTranslationCell.h"

@interface TD4WTranslationViewController ()

@property (nonatomic, strong) NSArray *languages;
@property (nonatomic, strong) NSArray *translations;

@end

@implementation TD4WTranslationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // This makes the status bar have light content

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12.5, 20.5)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back-highlighted"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    back.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:back];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:199.0/255.0 green:0.0 blue:2.0/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.languages = @[@"Afrikaans", @"Arabic", @"Bulgarian", @"Catalan", @"Chinese (Simplified)", @"Chinese (Traditional)", @"Czech", @"Danish", @"Dutch", @"Esperanto", @"Estonian", @"Filipino", @"Finnish", @"French", @"German", @"Greek", @"Hebrew", @"Hindi", @"Icelandic", @"Indonesian", @"Irish", @"Italian", @"Japanese", @"Korean", @"Lithuanian", @"Malay", @"Norwegian", @"Polish", @"Portuguese", @"Punjabi", @"Romanian", @"Russian", @"Serbian", @"Slovak", @"Spanish", @"Swedish", @"Turkish", @"Urdu", @"Vietnamese", @"Welsh", @"Yiddish"];
    
    self.translations = @[@"Draai af vir wat", @"رفض لما", @"Намалете силата на това, което", @"Baixi per la", @"调低什么", @"調低什麼", @"Otočte se na to, co", @"Skru ned for, hvad", @"Turn down voor wat", @"Turnu malsupren por kio", @"Keera mida", @"I-down para sa kung ano", @"Sammuta mitä", @"Baissez pour ce", @"Drehen Sie für das, was", @"Γυρίστε προς τα κάτω για το τι", @"לסרב למה", @"क्या के लिए नीचे बारी", @"Snúa niður fyrir það", @"Matikan untuk apa", @"Cas síos ar cad", @"Abbassate per quello", @"何のために断る", @"무엇을 줄이십시오", @"Sumažinkite už ką", @"Menolak untuk apa", @"Skru ned for hva", @"Zmniejsz o co", @"Abaixe para o que", @"ਕਿਸ ਲਈ ਟਰਨ ਡਾਊਨ", @"Rândul său, în jos de ce", @"Выключите за то, что", @"Окрените доле за оно", @"Otočte sa na to, čo", @"Baje por lo", @"Vänd ner för vad", @"Ne için aşağı çevirin", @"کیا کے لئے نیچے بند کر دیں", @"Từ chối cho những gì", @"Trowch i lawr ar gyfer yr hyn", @"קער אַראָפּ פֿאַר וואָס"];
    
    NSLog(@"%lu %lu", (unsigned long)self.languages.count, (unsigned long)self.translations.count);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TD4WTranslationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.languageLabel.text = [NSString stringWithFormat:@"%@:", self.languages[indexPath.row]];
    cell.translationLabel.text = self.translations[indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
