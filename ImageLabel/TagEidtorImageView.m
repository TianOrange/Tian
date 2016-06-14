//
//  TagEidtorImageView.m
//  ImageLabel
//
//  Created by Tian on 16/6/14.
//  Copyright © 2016年 Tian. All rights reserved.
//

#import "TagEidtorImageView.h"
#import "TJTagView.h"

@interface TagEidtorImageView()<UIGestureRecognizerDelegate>
{
    NSMutableArray *arrayTagS;
    NSMutableArray *arrayInitDidView;
    UIImage *imageLabelIcon;//标签
    TJTagView *viewTag;
    
    UIView *viewCover;
    UIView *viewMBP;
    
    UIButton *buttonOne;
    UIButton *buttonTwo;
    
    CGFloat imageScale;
    CGFloat viewTagLeft;
}
@end

@implementation TagEidtorImageView

//点击图片，点击标签
- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        arrayTagS = [NSMutableArray array];
        arrayInitDidView = [NSMutableArray array];
        imageLabelIcon = [UIImage imageNamed:@"textTag"];
        _imagePreviews = [self getimagePreviews];
        _imagePreviews.userInteractionEnabled = YES;
        [self addSubview:_imagePreviews];
        if (image == nil) {
            return self;
        }
        _imagePreviews.image = image;

        [self scaledFrame];//获得合适的frame
        [self initTagUI];
    }
    
    return self;
}
/**
 *  初始化MBP界面
 */
-(void)initTagUI{
    
    viewCover =[UIView new];
    viewCover.alpha=0;
    [self addSubview:viewCover];
    [viewCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    viewMBP =[UIView new];
    UITapGestureRecognizer* viewMBPTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickViewMBP)];
    viewMBPTag.numberOfTapsRequired=1;
    viewMBPTag.numberOfTouchesRequired=1;
    viewMBPTag.delegate = self;
    [viewMBP addGestureRecognizer:viewMBPTag]; //在viewMBP上添加手势
    [viewCover addSubview:viewMBP];
    [viewMBP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    buttonOne =[self getButtonOne];
    buttonOne.layer.cornerRadius=100/2;
    [viewCover addSubview:buttonOne];
    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-(100/1.3));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

}
-(void)clickViewMBP{
    [self mbpAnimation:NO];
}
#pragma -mark 初始化
-(UIImageView *)getimagePreviews{
    UIImageView *image =[UIImageView new];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickimagePreviews:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    tap.delegate = self;
    [image addGestureRecognizer:tap];
    return image;
}
#pragma -mark GestureRecognizer
/**
 *  标签移动
 */
-(void)panTagView:(UIPanGestureRecognizer *)sender{
    viewTag =(TJTagView *)sender.view;
    CGPoint point = [sender locationInView:_imagePreviews];
    if (sender.state ==UIGestureRecognizerStateBegan) {
        viewTagLeft =point.x-CGOriginX(viewTag.frame);
    }
    [self panTagViewPoint:point];
}
// pan手势  标签移动
-(void)panTagViewPoint:(CGPoint )point{
    [viewTag mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(point.x-viewTagLeft));
        make.top.equalTo(@(point.y-imageLabelIcon.size.height/2));
        if((point.x-viewTagLeft)<=0){
            make.left.equalTo(@0);
        }
        if (point.y+imageLabelIcon.size.height/2 >=CGRectGetHeight(_imagePreviews.frame)) {
            make.top.equalTo(@(CGRectGetHeight(_imagePreviews.frame)-imageLabelIcon.size.height));
        }
        if (point.y-imageLabelIcon.size.height/2 <= 0) {
            make.top.equalTo(@(0));
        }
        if (point.x+(CGWidth(viewTag.frame)-viewTagLeft) >=kWindowWidth) {
            make.left.equalTo(@(kWindowWidth-(CGWidth(viewTag.frame))));
        }
    }];
}
/**
 *  点击标签翻转
 */
-(void)tapTagView:(UITapGestureRecognizer *)sender{
    [self.delegate skipToNextViewcontroller];
}
-(void)tapTagView1:(UITapGestureRecognizer *)sender{
    viewTag =(TJTagView *)sender.view;
    [self viewTagIsPositiveAndNegative:viewTag.isPositiveAndNegative view:viewTag];
}
-(void)viewTagIsPositiveAndNegative:(BOOL)isPositiveAndNegative view:(TJTagView *)view{
    if(isPositiveAndNegative){
        view.isPositiveAndNegative=NO;
        [self positive:view];
    }else{
        view.isPositiveAndNegative=YES;
        [self negative:view];
    }
}
//正向
-(void)positive:(TJTagView *)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CGOriginX(view.frame)+CGWidth(view.frame)-8));
        if (CGRectGetMaxX(view.frame)+CGWidth(view.frame)-8 >=kWindowWidth) {
            make.left.equalTo(@(kWindowWidth-CGWidth(view.frame)));
        }
    }];
}
//反向
-(void)negative:(TJTagView *)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CGOriginX(view.frame)-CGWidth(view.frame)+8));
        if (CGOriginX(view.frame)-CGWidth(view.frame)+8<=0) {
            make.left.equalTo(@0);
        }
    }];
}
/**
 *  长按手势
 */
-(void)longTagView:(UILongPressGestureRecognizer *)sender{
    viewTag =(TJTagView *)sender.view;
    if (sender.state ==UIGestureRecognizerStateBegan) {
        [sender.view becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(menuItem1Pressed)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem2Pressed)];
        NSArray *menuItems = [NSArray arrayWithObjects:item1,item2,nil];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        [popMenu setTargetRect:sender.view.frame inView:_imagePreviews];
        [popMenu setMenuVisible:YES animated:YES];
    }
}
-(void)menuItem1Pressed{//编辑
    NSLog(@"bianji");
}
-(void)menuItem2Pressed{//删除
    for (TJTagView *tag in arrayTagS) {
        if ([tag isEqual: viewTag]) {
            [arrayTagS removeObject:tag];
            [tag removeFromSuperview];
            break;
        }
    }
}

/**
 *  点击图片
 */
-(void)clickimagePreviews:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:sender.view];//获得手势作用的坐标
    [self addtagViewimageClickinit:point isAddTagView:NO];
}
- (UIButton *)getButtonOne{
    UIButton *btn =[UIButton new];
    btn.backgroundColor=UIColorRGBA(0, 0, 0, 0.6);
    [btn setTitle:@"特点" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickButtonOne) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)clickButtonOne{
    viewTag.imageLabel.labelWaterFlow.text=@"图片上边打标签";
    viewTag.isImageLabelShow=YES;//显示出标签，NO是不显示标签
    [self clickViewMBP];
    [self correct:viewTag.imageLabel.labelWaterFlow.text isPositiveAndNegative:YES];//修正
}
-(void)correct:(NSString *)text isPositiveAndNegative:(BOOL)isPositiveAndNegative{
    CGSize size =[text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(11),NSFontAttributeName, nil]];
    CGFloat W;
    if (CGWidth(imageLabelIcon)-15 > size.width) {
        W=0;
    }else{
        W=size.width-(CGWidth(imageLabelIcon)-15);
    }
    
    if (CGOriginX(viewTag.frame)+(CGWidth(imageLabelIcon)+8+W) >=kWindowWidth) {
        [viewTag mas_updateConstraints:^(MASConstraintMaker *make) {
            if (isPositiveAndNegative) {
                viewTag.isPositiveAndNegative=YES;
                make.left.equalTo(@(CGOriginX(viewTag.frame)-(CGWidth(imageLabelIcon)+8+W)));
            }else{
                make.left.equalTo(@(CGRectGetMaxX(viewTag.frame)-(CGWidth(imageLabelIcon)+8+W)));
                
            }
            
        }];
    }
}


#pragma -mark 尺寸
-(void)scaledFrame{//图片充满屏幕
    CGRect noScale = CGRectMake(0.0, 0.0, _imagePreviews.image.size.width , _imagePreviews.image.size.height );
    if (CGWidth(noScale) <= kWindowWidth && CGHeight(noScale) <= self.frame.size.height) {
        imageScale = 1.0;
        _imagePreviews.frame= (CGRect){{kWindowWidth/2 -noScale.size.width/2,(kWindowHeight-64) /2 -noScale.size.height/2} ,noScale.size};
        return ;
    }
    CGRect scaled;
    imageScale= (kWindowHeight-64) / _imagePreviews.image.size.height;
    scaled=CGRectMake(0.0, 0.0, _imagePreviews.image.size.width * imageScale , _imagePreviews.image.size.height * imageScale );
    if (CGWidth(scaled) <= kWindowWidth && CGHeight(scaled) <= (kWindowHeight-64)) {
        _imagePreviews.frame= (CGRect){{kWindowWidth/2 -scaled.size.width/2,(self.frame.size.height-64) /2 -scaled.size.height/2} ,scaled.size};
        return ;
    }
    imageScale = kWindowWidth / _imagePreviews.image.size.width;//。。。以宽度为基准充满整个屏幕
    scaled = CGRectMake(0.0, 0.0, _imagePreviews.image.size.width * imageScale, _imagePreviews.image.size.height * imageScale);
    _imagePreviews.frame=(CGRect){{kWindowWidth/2 -scaled.size.width/2,(kWindowHeight-64) /2 -scaled.size.height/2} ,scaled.size};
}
#pragma -mark 添加已知标签

-(void)addTagViewText:(NSString *)text Location:(CGPoint )point isPositiveAndNegative:(BOOL)isPositiveAndNegative{
    CGFloat X;
    if (isPositiveAndNegative) {//1:   YES
        X = point.x*imageScale-8;
    }else{//0:
        X = point.x*imageScale;
    }
    CGPoint pointimageScale =CGPointMake(X, point.y*imageScale+imageLabelIcon.size.height/2);
    [self addtagViewimageClickinit:pointimageScale isAddTagView:YES];
    if(text.length!=0)
        viewTag.imageLabel.labelWaterFlow.text=text;
    [arrayInitDidView addObject:[NSString stringWithFormat:@"%d",isPositiveAndNegative]];
    
}
/*
- (void)didMoveToWindow {
    [self layoutIfNeeded];
    if (self.window) {
        if(!isViewDidLoad){
            isViewDidLoad=YES;
            for (int i=0; i<arrayInitDidView.count; i++) {
                NSLog(@"%d",![arrayInitDidView[i] boolValue]);
                if(![arrayInitDidView[i] boolValue]==YES)
                {
                    break;
                }
                [self viewTagIsPositiveAndNegative:![arrayInitDidView[i] boolValue] view:arrayTagS[i]];
            }
        }
    }
}*/

#pragma -mark 点击创建标签
-(void)addtagViewimageClickinit:(CGPoint)point isAddTagView:(BOOL)isAdd{
    
    //标签的view
    TJTagView *viewTagNew =[[TJTagView alloc]init];
    
    //添加拖动手势
    UIPanGestureRecognizer *panTagView =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTagView:)];
    //拖动手势的点击次数
    panTagView.minimumNumberOfTouches=1;
    panTagView.maximumNumberOfTouches=1;
    panTagView.delegate=self;
    [viewTagNew addGestureRecognizer:panTagView];//1.把拖动手势添加到标签上
    
    
    UITapGestureRecognizer* tapTagView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTagView:)];
    tapTagView.numberOfTapsRequired=1;
    tapTagView.numberOfTouchesRequired=1;
    tapTagView.delegate = self;
    [viewTagNew addGestureRecognizer:tapTagView];//2.添加点击手势到标签上
    
    UILongPressGestureRecognizer *longTagView =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTagView:)];
    longTagView.minimumPressDuration=0.5;
    longTagView.delegate=self;
    [viewTagNew addGestureRecognizer:longTagView];//3.添加长按手势到标签上
    
    [_imagePreviews addSubview:viewTagNew];//标签添加到图片上
    
    [viewTagNew mas_makeConstraints:^(MASConstraintMaker *make) {//页面布局
        make.left.equalTo(@(point.x));
        make.top.equalTo(@(point.y-imageLabelIcon.size.height/2));
        make.width.greaterThanOrEqualTo(@(viewTagNew.imageLabel.image.size.width+8));
        make.height.equalTo(@(imageLabelIcon.size.height));
    }];
    
    [arrayTagS addObject:viewTagNew];
    viewTag=viewTagNew;
    
    //
    if (!isAdd) {
        [self mbpAnimation:YES];
    }else{
        viewTagNew.isImageLabelShow=YES;
    }
}
/**
 *  mbp界面的动画
 */
-(void)mbpAnimation:(BOOL)animation{//传来NO,添加标签的button的消失; YES 则button不消失
    if (animation) {//不消失
        [UIView animateWithDuration:0.1 animations:^{
            viewCover.alpha=1;
            buttonOne.transform=CGAffineTransformMakeScale(1.2, 1.2);
            buttonTwo.transform=CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
                buttonOne.transform=CGAffineTransformIdentity;
                buttonTwo.transform=CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                
            }];
        }];
    }else{//消失
        [UIView animateWithDuration:0.1 animations:^{
            viewCover.alpha=0;
        }completion:^(BOOL finished) {
            NSLog(@"arrayTagS.count:%lu",(unsigned long)arrayTagS.count);
            if (arrayTagS.count !=0) {
                TJTagView *tag =[arrayTagS lastObject];
                if (!tag.isImageLabelShow) {
                    [tag removeFromSuperview];
                    [arrayTagS removeLastObject];
                }
            }
        }];
        
    }
    
}

@end
