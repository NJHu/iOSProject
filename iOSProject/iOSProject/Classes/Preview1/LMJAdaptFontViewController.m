//
//  LMJAdaptFontViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/18.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "LMJAdaptFontViewController.h"
#import "LMJAdaptFontCell.h"

@interface LMJAdaptFontViewController ()

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<LMJParagraph *> *paragraphs;

@end

@implementation LMJAdaptFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paragraphs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.paragraphs[indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMJAdaptFontCell *cell = [LMJAdaptFontCell adaptFontCellWithTableView:tableView];
    
    cell.paragraph = self.paragraphs[indexPath.row];
    
    return cell;
}


#pragma mark 重写BaseViewController设置内容

- (UIColor *)lmjNavigationBackgroundColor:(LMJNavigationBar *)navigationBar
{
    return [UIColor RandomColor];
}

- (void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}

- (void)titleClickEvent:(UILabel *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    NSLog(@"%@", sender);
}

- (NSMutableAttributedString*)lmjNavigationBarTitle:(LMJNavigationBar *)navigationBar
{
    return [self changeTitle:@"字体适配[原iPhone 6]"];;
}

- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"navigationButtonReturnClick"];
}



- (UIImage *)lmjNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(LMJNavigationBar *)navigationBar
{
    
    rightButton.backgroundColor = [UIColor RandomColor];
    
    return nil;
}



#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor RandomColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}


- (NSMutableArray<LMJParagraph *> *)paragraphs
{
    if(!_paragraphs)
    {
        NSArray *datas = [NSMutableArray arrayWithArray:@[@"岐王宅里寻常见，崔九堂前几度闻。正是江南好风景，落花时节又逢君。",@"意在抒写边防将士之乡情。前二句写月下边塞的景色；三句写声音，闻见芦管悲声；四句写心中感受，芦笛能动征人回乡之望。全诗把景色、声音，感受融为一体，意境浑成。《唐诗纪事》说这首诗在当时便被度曲入画。仔细体味全诗意境，确也是谱歌作画的佳品",@"平凡的寺，平凡的钟，经过诗人艺术的再创造，就构成了一幅情味隽永幽静诱人的江南水乡的夜景图，成为流传古今的名作、名胜。此诗自从欧阳修说了“三更不是打钟时”之后，议论颇多。其实寒山寺夜半鸣钟却是事实，直到宋化仍然。宋人孙觌的《过枫桥寺》诗：“白首重来一梦中，青山不改旧时容。乌啼月落桥边寺，倚枕犹闻半夜钟。”即可为证。张继大概也以夜半鸣钟为异，故有“夜半钟声”一句。今人或以为“乌啼”乃寒山寺以西有“乌啼山”，非指“乌鸦啼叫。”“愁眠”乃寒山寺以南的“愁眠山”，非指“忧愁难眠”。殊不知“乌啼山”与“愁眠山”，却是因张继诗而得名。孙觌的“乌啼月落桥边寺”句中的“乌啼”，即是明显指“乌啼山”",@"江雨霏霏江草齐，六朝如梦鸟空啼。无情最是台城柳，依旧烟笼十里堤。",@"诗的首句写梦中重聚，难舍难离；二句写依旧当年环境，往日欢情；三句写明月有情，伊人无义；四句写落花有恨，慰藉无人。前二句是表明自己思念之深；后两句是埋怨伊人无情，鱼沉雁杳。以明月有情，寄希望于对方，含蓄深厚，曲折委婉，情真意真。",@"首句写所见（月落），所闻（乌啼），所感（霜满天）；二句描绘枫桥附近的景色和愁寂的心情；三、四句写客船卧听古刹钟声。平凡的桥，平凡的树，平凡的水，平凡的寺，平凡的钟，经过诗人艺术的再创造，就构成了一幅情味隽永幽静诱人的江南水乡的夜景图，成为流传古今的名作、名胜。此诗自从欧阳修说了“三更不是打钟时”之后，议论颇多。其实寒山寺夜半鸣钟却是事实，直到宋化仍然。宋人孙觌的《过枫桥寺》诗：“白首重来一梦中，青山不改旧时容。乌啼月落桥边寺，倚枕犹闻半夜钟。”即可为证。张继大概也以夜半鸣钟为异，故有“夜半钟声”一句。今人或以为“乌啼”乃寒山寺以西有“乌啼山”，非指“乌鸦啼叫。”“愁眠”乃寒山寺以南的“愁眠山”，非指“忧愁难眠”。殊不知“乌啼山”与“愁眠山”，却是因张继诗而得名。孙觌的“乌啼月落桥边寺”句中的“乌啼”，即是明显指“乌啼山”。"]];
        
        _paragraphs = [NSMutableArray array];
        
        [datas enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LMJParagraph *pa = [[LMJParagraph alloc] init];
            pa.words = obj;
            pa.date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd ss"];
            [self->_paragraphs addObject:pa];
        }];
    }
    return _paragraphs;
}

@end










