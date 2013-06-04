# -*- coding: UTF-8 –*-
__author__ = 'watsy'

from django.db import models



class dbBlog(models.Model):

    CT_WEB = 0
    CT_IPHONE = 1
    CT_IPAD = 2
    CT_ANDROID = 3

    BLOG_COME_TYPE = (

        (CT_WEB, 'web'),
        (CT_IPHONE, 'iphone'),
        (CT_IPAD, 'ipad'),
        (CT_ANDROID, 'android'),
    )

    title = models.CharField(max_length=64)
    deviceType = models.IntegerField(
        choices=BLOG_COME_TYPE,
        default= CT_WEB,
    )
    created_date = models.DateTimeField(auto_now_add=True)
    content = models.TextField()
    visitCount = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return self.title

    class Meta:
        ordering = ('-created_date',)

class dbLoginKey(models.Model):

    #用户ID
    userID = models.IntegerField()
    #校验码
    token = models.CharField(max_length=32)
    #最后使用时间
    last_date = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return self.token



