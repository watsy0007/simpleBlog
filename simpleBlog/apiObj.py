__author__ = 'watsy'

import json

class API_Object(object):

    def __init__(self, status = 1, err_code = 0, datas = {}):
        self.status = status
        self.errcode = err_code
        self.datas = datas

    def json_data(self, dataName = 'datas'):
        return """{"status":%d,"errcode":%d, "%s":%s}""" % (self.status, self.errcode, dataName, json.dumps(self.datas))
