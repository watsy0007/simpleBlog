# -*- coding: UTF-8 –*-
__author__ = 'watsy'

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render_to_response
import simpleBlog.models
from simpleBlog.models import dbBlog ,dbLoginKey
from django.core.paginator import Paginator, InvalidPage, EmptyPage, PageNotAnInteger
from django.core.exceptions import ObjectDoesNotExist

from django.utils import timezone
from django.utils import simplejson
from django.core import serializers
from django.views.decorators.csrf import csrf_exempt
import json
from  django.contrib.auth import authenticate
from django.contrib.auth.models import User
from apiObj import API_Object
import hashlib
import datetime
import settings

#web
def index(request):

    #确保按照最后添加的在最前的顺序显示
    blogs = dbBlog.objects.order_by('-created_date').all()

    #以下内容为页码处理
    #参考http://2goo.info/blog/baoyalv/Django/2010/04/15/67
    page_size = 10
    after_range_num = 5
    before_range_num = 6

    try:
        page = int(request.GET.get("page" , 1))
        if page < 1:
            page = 1
    except ValueError:
        page = 1

    paginator = Paginator(blogs , page_size)

    try:
        blogs = paginator.page(page)
    except(EmptyPage, InvalidPage, PageNotAnInteger):
        blogs = paginator.page(1)

    if page > after_range_num:
        page_range = paginator.page_range[page-after_range_num : page + before_range_num]
    else:
        page_range = paginator.page_range[0 : int(page) + before_range_num]



    return render_to_response(
        'index.html',
        {
            'blogs' : blogs ,
            'page_range' : page_range
        }
    )


def blog(request, blogId):

    blogObj = dbBlog.objects.get(id=int(blogId))

    blog_pre = 0
    blog_next = 0

    #上1页
    if int(blogId) - 1 > 0 and \
            dbBlog.objects.get(pk=(int (blogId) - 1)):
        blog_pre = (int (blogId) - 1)

    #下1页
    if int(blogId) + 1 < dbBlog.objects.count() and \
            dbBlog.objects.get(pk=(int (blogId) + 1)):
        blog_next = (int (blogId) + 1)

    return render_to_response(
        'blog.html',

        {
            'blog' : blogObj,
            'blog_pre' : blog_pre,
            'blog_next' : blog_next
        }

    )



#api
def isUserLogined(userId, token):
    login = dbLoginKey.objects.get(userID=str(userId), token = str(token))
    #登录过
    if login is not None:
        #时间没超过1天
        print login.last_date
        print login.last_date.utctimetuple()

        if (login.last_date - timezone.now()).days == 0:
            login.last_date = datetime.datetime.utcnow()
            login.save()
            return True
        else:
            login.delete()

    return False

#api
#客户端提交的post如果不加这段，会出现403error
@csrf_exempt
def api_blogs(request):

    json_api = API_Object(0)

    if request.method == 'POST' and request.POST.get('page'):
        int_page = int(request.POST['page'])
    else:
        int_page = 1

    blogs = dbBlog.objects.order_by('-created_date').all()

    page_size = 10

    paginator = Paginator(blogs, page_size)

    try:
        blogs = paginator.page(int_page)
    except(EmptyPage, InvalidPage, PageNotAnInteger):
        blogs = paginator.page(1)

    try:

        json_api.datas = serializers.serialize('json',blogs.object_list)
        json_api.status = 1
    except :

        json_api.errcode = 1000




    return HttpResponse(
        json_api.json_data('blogs')
    )

@csrf_exempt
def api_login(request):
    json_login = {}
    json_api = API_Object(0)

    if request.method == 'POST':
        if request.POST.get('username') and request.POST.get('password'):
            user = authenticate(username = request.POST['username'], password = request.POST['password'])
            if user is not None:

                try:
                    loginUser  = dbLoginKey.objects.get(userID = user.id)
                    if loginUser is None:
                        raise ObjectDoesNotExist
                except ObjectDoesNotExist:
                    loginUser = dbLoginKey()

                loginUser.token = hashlib.md5().hexdigest()

                loginUser.last_date = datetime.datetime.utcnow()
                loginUser.userID = user.id
                loginUser.save()
                json_login['userid'] = user.id
                json_login['token'] = loginUser.token

                json_api.status = 1

    json_api.datas = json_login

    return HttpResponse(
        json_api.json_data('userObj')
    )


#add blog
@csrf_exempt
def api_addBlog(request):

    return_json = {}
    json_api = API_Object(0)

    #需要提交
    #userid token title content device

    if request.method == 'POST':
        if request.POST.get('userid') and request.POST.get('token'):
            userid =     request.POST['userid']
            token =     request.POST['token']
            #校验
            if isUserLogined(userid, token):

                #提交

                if request.POST.get('title') and request.POST.get('content'):
                    insert_blog = dbBlog()
                    insert_blog.title = request.POST['title']
                    insert_blog.content = request.POST['content']
                    insert_blog.visitCount = 0

                    if request.POST.get('device'):
                        if str(request.POST['device']).lower() == 'iphone':
                            insert_blog.deviceType = 1
                        elif str(request.POST['device']).lower() == 'ipad':
                            insert_blog.deviceType = 2
                        elif str(request.POST['device']).lower() == 'android':
                            insert_blog.deviceType = 3
                        else:
                            insert_blog.deviceType = 0
                    else:
                        insert_blog.deviceType = 0

                    dbBlog.save(insert_blog)
                    json_api.status = 1


    return HttpResponse(json_api.json_data())



