# -*- coding: UTF-8 –*-
__author__ = 'watsy'

from django.db import models

class dbBlog(models.Model):

    title = models.CharField(max_length=64)
    created_date = models.DateTimeField(auto_now_add=True)
    content = models.TextField()
    visitCount = models.IntegerField(blank=True, null=True)

    def __unicode__(self):
        return self.title

    class Meta:
        ordering = ('-created_date',)
