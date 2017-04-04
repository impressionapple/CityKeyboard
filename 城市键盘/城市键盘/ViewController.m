//
//  ViewController.m
//  城市键盘
//
//  Created by alading on 2017/2/28.
//  Copyright © 2017年 liwenquan. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *city;
/**省会加载*/
@property(nonatomic,strong)NSArray *provinces;
/**城市的加载*/
@property(nonatomic,strong)NSArray *citys;
/**区域的加载*/
@property(nonatomic,strong)NSArray *towns;
@property (strong, nonatomic) NSArray *selectedArray;
/**PickerView*/
@property(nonatomic,weak)UIPickerView *pickerView;

/**选中的第一列选中的哪一行*/
@property(nonatomic,assign)NSInteger proIndex;
/**pickerView的字典*/
@property(nonatomic,strong)NSDictionary *pickerDic;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
      //自定义城市键盘
     [self setUpCityKeyboard];
    
    //初始化数据
    [self setUpData];
  
   
   
}


-(void)setUpData{
    // 加载plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Address.plist" ofType:nil];
    
    self.pickerDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    self.provinces = [self.pickerDic allKeys];
    
    // 默认选中第一组
    self.selectedArray = [self.pickerDic objectForKey:[self.provinces objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.citys = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.citys.count > 0) {
        self.towns = [[self.selectedArray objectAtIndex:0] objectForKey:[self.citys objectAtIndex:0]];
    }

}


-(void)setUpCityKeyboard{
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    _pickerView = pickerView;
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    _city.inputView = pickerView;
    
}

#pragma mark - UIPickerView的数据源

//有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

//每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.provinces.count;
    }else if (component ==1){
        return self.citys.count;
    }else{
        return self.towns.count;
    }
}

//每一列的样子
#pragma mark - UIPickerView的代理
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component ==0) {
        return [self.provinces objectAtIndex:row];
    }else if (component ==1){
        return [self.citys objectAtIndex:row];
    }else{
        return [self.towns objectAtIndex:row];
    }
}


// 滚动UIPickerView就会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    if (component ==0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinces objectAtIndex:row]]; // 选中第一组
        if (self.selectedArray.count > 0) {
            self.citys = [[self.selectedArray objectAtIndex:0] allKeys];
        }else{
            self.citys = nil;
        }
        if (self.citys.count >0) {
            self.towns = [[self.selectedArray objectAtIndex:0]objectForKey:[self.citys objectAtIndex:0]];
        }else{
            self.towns = nil;
        }
    }

    [pickerView reloadComponent:1];

    
    if (component ==1) {
        if (self.selectedArray.count >0 && self.citys.count >0) {
            self.towns = [[self.selectedArray objectAtIndex:0]objectForKey:[self.citys objectAtIndex:row]];
        }else{
            self.towns = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
    
    
    
    
    
    
    
    NSInteger index0 = [pickerView selectedRowInComponent:0];
    NSString *provinces0 = [self.provinces objectAtIndex:index0];
    
    
    NSInteger index1 = [pickerView selectedRowInComponent:1];
    NSString *city1 = [self.citys objectAtIndex:index1];
    
    NSInteger index2 = [pickerView selectedRowInComponent:2];
    NSString *town2 = [self.towns objectAtIndex:index2];
    _city.text = [NSString stringWithFormat:@"%@-%@-%@",provinces0,city1,town2];
    

    
    
    
}







@end
