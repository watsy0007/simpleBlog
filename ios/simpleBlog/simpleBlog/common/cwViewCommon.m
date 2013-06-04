//
// Created by  王 岩 on 13-6-3.
// Copyright (c) 2013  王 岩. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "cwViewCommon.h"
#import "../../Pods/AttributedMarkdown/markdown_lib.h"
#import "../../Pods/AttributedMarkdown/markdown_peg.h"


@implementation cwViewCommon

+ (NSMutableDictionary *) getMarkdownAttributes
{
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc]init];

    // p

    UIFont *paragraphFont = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0];
    NSMutableParagraphStyle* pParagraphStyle = [[NSMutableParagraphStyle alloc]init];

    pParagraphStyle.paragraphSpacing = 12;
    pParagraphStyle.paragraphSpacingBefore = 12;
    NSDictionary *pAttributes = @{
            NSFontAttributeName : paragraphFont,
            NSParagraphStyleAttributeName : pParagraphStyle,
    };

    [attributes setObject:pAttributes forKey:@(PARA)];

    // h1
    UIFont *h1Font = [UIFont fontWithName:@"AvenirNext-Bold" size:24.0];
    [attributes setObject:@{NSFontAttributeName : h1Font} forKey:@(H1)];

    // h2
    UIFont *h2Font = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0];
    [attributes setObject:@{NSFontAttributeName : h2Font} forKey:@(H2)];

    // h3
    UIFont *h3Font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0];
    [attributes setObject:@{NSFontAttributeName : h3Font} forKey:@(H3)];

    // em
    UIFont *emFont = [UIFont fontWithName:@"AvenirNext-MediumItalic" size:15.0];
    [attributes setObject:@{NSFontAttributeName : emFont} forKey:@(EMPH)];

    // strong
    UIFont *strongFont = [UIFont fontWithName:@"AvenirNext-Bold" size:15.0];
    [attributes setObject:@{NSFontAttributeName : strongFont} forKey:@(STRONG)];

    // ul
    NSMutableParagraphStyle* listParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    listParagraphStyle.headIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listParagraphStyle} forKey:@(BULLETLIST)];

    // li
    NSMutableParagraphStyle* listItemParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    listItemParagraphStyle.headIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listItemParagraphStyle} forKey:@(LISTITEM)];

    // a
    UIColor *linkColor = [UIColor blueColor];
    [attributes setObject:@{NSForegroundColorAttributeName : linkColor} forKey:@(LINK)];

    // blockquote
    NSMutableParagraphStyle* blockquoteParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    blockquoteParagraphStyle.headIndent = 16.0;
    blockquoteParagraphStyle.tailIndent = 16.0;
    blockquoteParagraphStyle.firstLineHeadIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : [emFont fontWithSize:18.0], NSParagraphStyleAttributeName : blockquoteParagraphStyle} forKey:@(BLOCKQUOTE)];

    // verbatim (code)
    NSMutableParagraphStyle* verbatimParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    verbatimParagraphStyle.headIndent = 12.0;
    verbatimParagraphStyle.firstLineHeadIndent = 12.0;
    UIFont *verbatimFont = [UIFont fontWithName:@"CourierNewPSMT" size:14.0];
    [attributes setObject:@{NSFontAttributeName : verbatimFont, NSParagraphStyleAttributeName : verbatimParagraphStyle} forKey:@(VERBATIM)];

    return [attributes autorelease];
}

@end