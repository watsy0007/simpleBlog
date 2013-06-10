package com.watsy.simpleblog;

/**
 * Created by watsy on 13-6-10.
 */
public interface AnsycCallBack
{
    //还可以添加错误代码判断，这里就不写了
    public void didFinished(String action, Object obj);
    public void didFailed(String action);
}
