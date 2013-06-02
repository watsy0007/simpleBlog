# -*- coding: UTF-8 –*-
__author__ = 'watsy'

from django.http import HttpRequest, HttpResponse
from django.shortcuts import render_to_response
from simpleBlog.models import dbBlog
from django.core.paginator import Paginator, InvalidPage, EmptyPage, PageNotAnInteger

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