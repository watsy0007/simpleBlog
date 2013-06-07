#!/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'watsy'


import sys
from PyQt4 import QtGui, QtCore
from PyQt4.QtWebKit import QWebView
from httpReq import simpleBlogRequest
import models
import markdown

from django.contrib import markup

class MainDialog(QtGui.QWidget):

    def __init__(self):

        super(MainDialog, self).__init__()

        self.initDatas()
        self.initUI()
        self.bindSignal()
        self.initDemo()


    def initUI(self):

        # name pass login
        # list
        # web view
        # -----add blog----
        # title
        # blog
        # submit

        #name
        self.namefield = QtGui.QLineEdit( '' , self )
        self.namefield.setPlaceholderText('帐号')
        self.namefield.setAlignment(QtCore.Qt.AlignCenter)

        #pass
        self.passfield = QtGui.QLineEdit( '' , self )
        self.passfield.setPlaceholderText('密码')
        self.passfield.setAlignment(QtCore.Qt.AlignCenter)
        self.passfield.setEchoMode(QtGui.QLineEdit.PasswordEchoOnEdit)

        #login
        self.loginbutton = QtGui.QPushButton( 'login' , self )

        #layout
        hbox = QtGui.QHBoxLayout()
        hbox.addWidget(self.namefield)
        hbox.addWidget(self.passfield)
        hbox.addWidget(self.loginbutton)

        #list
        self.bloglistModel = QtGui.QStandardItemModel()
        self.bloglistView = QtGui.QListView( self )
        self.bloglistView.setModel(self.bloglistModel)
        self.bloglistView.setEditTriggers(QtGui.QAbstractItemView.NoEditTriggers)

        #webview
        self.webView = QWebView( self )


        #post
        label = QtGui.QLabel( self )
        label.setText( '------------post blog------------' )
        self.titleEdit = QtGui.QLineEdit( self )
        self.titleEdit.setPlaceholderText( 'title' )
        self.contentEdit = QtGui.QTextEdit( self )

        self.addbutton = QtGui.QPushButton ( 'post' , self )


        vpostBox = QtGui.QVBoxLayout()
        vpostBox.addWidget( label )
        vpostBox.addWidget( self.titleEdit )
        vpostBox.addWidget( self.contentEdit )
        vpostBox.addWidget( self.addbutton  )

        #layout
        vbox = QtGui.QVBoxLayout()
        vbox.addLayout( hbox )
        vbox.addWidget( self.bloglistView )
        vbox.addWidget( self.webView )
        vbox.addLayout( vpostBox )

        self.setLayout( vbox )

        #resize
        screenSize = QtGui.QDesktopWidget().availableGeometry()

        self.setGeometry( screenSize.width() - 300 , 0 , 300 , screenSize.height())
        self.setWindowTitle( 'simple blog' )
        self.show()

    def initDatas(self):

        self.login = False
        #data
        self.httpReq = simpleBlogRequest( self , 'http://127.0.0.1:8000/api/')
        self.httpReq.didFinished[QtCore.QString,QtCore.QString].connect(self.didFinishedRequest)

        self.blogs = models.blogModel()
        self.user = models.userObject()


    def bindSignal(self):

        self.loginbutton.clicked.connect( self.actionLogin )
        # self.connect(self.bloglistView, QtCore.SIGNAL('selectionChanged(QItemSelection,QItemSelection)'), self.actionSelectionListViewIndex)
        self.bloglistView.clicked.connect( self.actionSelectionListViewIndex )

        self.addbutton.clicked.connect( self.actionAddBlog )


    def initDemo(self):

        self.namefield.setText( 'watsy' )
        self.passfield.setText( '258841679' )


    #刷新获取所有列表
    def actionGetBlogs(self):

        reply = self.httpReq.getBlogs()


    # 成功返回
    def didFinishedRequest(self , action , data):

        if action == 'login':

            self.login = True
            self.user.parserUserObj( data )

            select = QtGui.QMessageBox.information(self , 'login' , 'login succeed' , QtGui.QMessageBox.Yes)
            if select == QtGui.QMessageBox.Yes:
                self.actionGetBlogs()

        elif action == 'blogs':

            self.bloglistModel.removeRows(0 , self.bloglistModel.rowCount())

            self.blogs.parserBlogFromJsonString(data)
            blogs = self.blogs.titleArray()
            for title in blogs:
                item = QtGui.QStandardItem(title)
                self.bloglistModel.appendRow(item)


        elif action == 'addblog':
            self.blogs.reset()
            self.actionGetBlogs()




    #signal

    #登录
    def actionLogin(self):

        self.blogs.reset()
        reply = self.httpReq.login( self.namefield.text(), self.passfield.text() )



    #增加微博
    def actionAddBlog(self):

        if not self.login:
            QtGui.QMessageBox.warning( self , 'un login' , 'please login in first')
            return

        # title and content check
        self.httpReq.addBlog( self.titleEdit.text() , self.contentEdit.toPlainText() ,
                              self.user.userId , self.user.token)



    # 点击list view
    def actionSelectionListViewIndex(self , selectIndex):

        index = selectIndex.row()

        blog = self.blogs.getObjectAtIndex( index )


        self.webView.setHtml(markdown.markdown(blog.content))





def main():

    app = QtGui.QApplication(sys.argv)
    maindialog = MainDialog()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()