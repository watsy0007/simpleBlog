__author__ = 'watsy'

from models import dbBlog
from django.contrib import admin


class dbBlogAdmin(admin.ModelAdmin):
    list_display = ('title' , 'created_date' , 'content' , 'visitCount')


admin.site.register(dbBlog, dbBlogAdmin)