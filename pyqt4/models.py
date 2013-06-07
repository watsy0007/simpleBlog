#!/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'watsy'

import json

class blogObject (object):

    def __init__(self , pk = 1, title = '' , content = '' , visitCount = '' , created_date = '' , deviceType = 1):

        super( blogObject , self) .__init__()

        self.pk = pk
        self.title = title
        self.content = content
        self.visitCount = visitCount
        self.create_date = created_date
        self.deviceType = deviceType


class userObject (object):

    def __init__(self , token = '', userid = 1):

        super( userObject , self).__init__()
        self.token = token
        self.userId = userid


    def parserUserObj(self , msg):

        json_data = json.loads(str(msg))

        self.token = json_data['userObj']['token']
        self.userId = json_data['userObj']['userid']



class blogModel(object):

    def __init__(self):

        super(blogModel , self).__init__()

        self.blogs = []


    def reset(self):
        del self.blogs[:]

    def getCount(self):

        return len(self.blogs)


    def getObjectAtIndex(self , nIndex):

        if nIndex <= len(self.blogs):
            return self.blogs[nIndex]

        return None


    def pageIndex(self):

        return 20


    def titleArray(self):

        titles = []

        for blog in self.blogs:
            titles.append(blog.title)

        return titles


    def parserBlogFromJsonString(self , str_json):

        json_data = json.loads(str(str_json))

        fields = json.loads(json_data[u'blogs'])
        for dict_str in fields:

            blog = blogObject(dict_str['pk'] , dict_str['fields']['title'] ,
                              dict_str['fields']['content'] , dict_str['fields']['visitCount'] ,
                              dict_str['fields']['created_date'] , dict_str['fields']['deviceType'])

            self.blogs.append(blog)




