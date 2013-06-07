#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'watsy'

from PyQt4.QtNetwork import QNetworkAccessManager , QNetworkRequest , QNetworkReply
from PyQt4 import QtCore
from PyQt4.QtCore import QObject, pyqtSignal , pyqtSlot
import json

class blogRequest(object):

    def __init__(self , parent , action):

        super ( blogRequest , self).__init__()

        self.parent = parent
        self.action = action

    def post(self, mgr , url , datas):

        request = QNetworkRequest(QtCore.QUrl(url))
        request.setHeader(QNetworkRequest.ContentTypeHeader,"application/x-www-form-urlencoded")

        self.reply = mgr.post(request , datas)

        self.reply.finished.connect(self.replyfinished)
        self.reply.readyRead.connect(self.readyRead)
        return self.reply

    def get(self, mgr , url):

        request = QNetworkRequest(QtCore.QUrl(url))

        self.reply = mgr.get(request)

        self.reply.finished.connect(self.replyfinished)
        self.reply.readyRead.connect(self.readyRead)
        return self.reply


    def replyfinished(self):
        #通知父类释放
        self.parent.replyfinished( self )


    def readyRead(self):
        #通知父类读取
        self.parent.readyRead( self )



class simpleBlogRequest(QObject):

    didFinished = QtCore.pyqtSignal(QtCore.QString,QtCore.QString)

    def __init__(self , msgParent , baseURL = ''):

        super(simpleBlogRequest , self).__init__()

        self.baseURL = baseURL
        self.notiUI = msgParent
        self.netMgr = QNetworkAccessManager( msgParent )

        # self.

        #signal
        QObject.connect( self.netMgr , QtCore.SIGNAL("finished(QNetworkReply)") , self.finished)

        #post list
        self.postlist = []


    def login(self , name , password):

        #url
        url = self.baseURL + 'login'

        #params
        params = QtCore.QUrl()
        params.addQueryItem('username' , str(name))
        params.addQueryItem('password' , str(password))

        datas = QtCore.QByteArray()
        datas = params.encodedQuery()

        postReq = blogRequest( self , 'login')
        netreply = postReq.post(self.netMgr , url , datas)
        self.postlist.append( postReq )

        return netreply

    def getBlogs(self):

        url = self.baseURL + 'blogs'

        blogReq = blogRequest ( self , 'blogs' )
        blogReq.get( self.netMgr , url )
        self.postlist.append(blogReq)



    def addBlog(self , title , content , userid , token):

        url = self.baseURL + 'addblog'

         #params
        params = QtCore.QUrl()
        params.addQueryItem('title' , str(title))
        params.addQueryItem('content' , str(content))
        params.addQueryItem('userid' , str(userid))
        params.addQueryItem('device' , 'macos10.8')
        params.addQueryItem('token' , str(token))

        datas = QtCore.QByteArray()
        datas = params.encodedQuery()

        postReq = blogRequest( self , 'addblog')
        netreply = postReq.post(self.netMgr , url , datas)
        self.postlist.append( postReq )

        return netreply



    def finished(self , reply):
        print 'finished'
        print 'xxx ' + reply


    def replyfinished(self , postReq):
        self.postlist.remove(postReq)


    def readyRead(self , postReq):

        msg = postReq.reply.readAll()
        self.msgDispatch( postReq.action , msg)


    def msgDispatch(self, action , msg):

        msg = str(msg)
        json_datas = json.loads(msg)

        # print json_datas
        #not error
        print msg
        if json_datas['status'] and not json_datas['errcode']:

            self.didFinished.emit( action , msg )

        else:

            pass










