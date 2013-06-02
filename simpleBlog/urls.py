from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

from views import index, blog

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'simpleBlog.views.home', name='home'),
    # url(r'^simpleBlog/', include('simpleBlog.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),

    #blog detail
    url(r'^blog/(\d+)', view=blog , name='blog_detail'),
    #index
    url(r'^$', view=index, name= 'blog_index'),
)
