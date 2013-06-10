package com.watsy.simpleblog;

/**
 * Created by watsy on 13-6-9.
 */

import android.util.Property;
import com.turbomanage.httpclient.ParameterMap;
import java.util.ArrayList;
import com.turbomanage.httpclient.android.AndroidHttpClient;
import com.turbomanage.httpclient.AsyncCallback;
import com.turbomanage.httpclient.HttpResponse;
import org.json.JSONException;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import com.watsy.simpleblog.AnsycCallBack;


public class BlogModel extends Object
{
    private String  s_baseURL;
    private AnsycCallBack           _callBack;

    private ArrayList<BlogObject>   _blogs;

    final UserObject    _userObj;

    public static String API_ACTION_LOGIN =     "login";
    public static String API_ACTION_GETBLOGS =  "blogs";
    public static String API_ACTION_ADDBLOG =   "addblog";



    public BlogModel(String baseURL, AnsycCallBack cb)
    {
        super();

        this.s_baseURL = baseURL;
        this._callBack = cb;
        _blogs = new ArrayList<BlogObject>();

        _userObj = new UserObject();

    }


    public void login(String username, String password)
    {

        AndroidHttpClient httpClient = new AndroidHttpClient( this.s_baseURL );
//        httpClient.setMaxRetries(5);
        ParameterMap params = httpClient.newParams()
                .add("username" , username )
                .add("password" , password );

        httpClient.post("/api/" + API_ACTION_LOGIN , params , new AsyncCallback() {

            @Override
            public void onComplete(HttpResponse httpResponse)
            {
                try
                {
                    JSONParser parser = new JSONParser();
                    JSONObject obj = (JSONObject)parser.parse(httpResponse.getBodyAsString());

                    long status = (Long) obj.get("status");
                    JSONObject json_userObj = (JSONObject) obj.get("userObj");

                    if (status == 1)
                    {
                        _userObj.userid = (Long) json_userObj.get("userid");
                        _userObj.token = (String) json_userObj.get("token");
                    }

                    _callBack.didFinished(API_ACTION_LOGIN , _userObj);
                }
                catch (ParseException e)
                {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Exception e)
            {
                e.printStackTrace();
            }
        });


    }

    public void getblogs()
    {

        AndroidHttpClient androidHttpClient = new AndroidHttpClient( this.s_baseURL );

        androidHttpClient.get("/api/" + API_ACTION_GETBLOGS, new ParameterMap() , new AsyncCallback() {
            @Override
            public void onComplete(HttpResponse httpResponse)
            {
                try
                {
                    JSONParser parser = new JSONParser();
                    JSONObject obj = (JSONObject)parser.parse(httpResponse.getBodyAsString());

                    long status = (Long) obj.get("status");
                    JSONObject json_userObj = (JSONObject) obj.get("userObj");

                    if (status == 1)
                    {
                        JSONParser blogdetailparser = new JSONParser();
                        JSONArray array_blog = (JSONArray) blogdetailparser.parse( (String)obj.get("blogs") );
                        for (int i = 0; i < array_blog.size(); i++ )
                        {
                            JSONObject blogDetail = (JSONObject)array_blog.get(i);
                            System.out.print( blogDetail );

                            BlogObject blogObject = new BlogObject();

                            blogObject.pk = (Long) blogDetail.get( "pk" );
                            blogObject.title = (String) ((JSONObject)blogDetail.get( "fields" )).get("title");
                            blogObject.content = (String) ((JSONObject)blogDetail.get( "fields" )).get("content");

                            _blogs.add( blogObject );
                        }
                    }

                    _callBack.didFinished(API_ACTION_GETBLOGS , _userObj);
                }
                catch (ParseException e)
                {
                    e.printStackTrace();
                }
            }
            @Override
            public void onError(Exception e)
            {
                e.printStackTrace();
            }
        });

    }

    public void addBlog( String title, String content )
    {
        AndroidHttpClient httpClient = new AndroidHttpClient( this.s_baseURL );
        ParameterMap params = httpClient.newParams()
                .add( "title" ,     title           )
                .add( "content" ,   content         )
                .add( "userid" ,    Long.toString(_userObj.userid) )
                .add( "token" ,     _userObj.token  )
                .add( "device" ,    "3"             );

        httpClient.post( "/api/" + API_ACTION_ADDBLOG , params , new AsyncCallback() {
            @Override
            public void onComplete(HttpResponse httpResponse) {
                try
                {
                    JSONParser parser = new JSONParser();
                    JSONObject obj = (JSONObject)parser.parse(httpResponse.getBodyAsString());

                    long status = (Long) obj.get("status");

                    if (status == 1)
                    {

                    }

                    _callBack.didFinished( API_ACTION_ADDBLOG , _userObj);
                }
                catch (ParseException e)
                {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(Exception e)
            {
                e.printStackTrace();
            }
        } );
    }

    public void reset()
    {
        _blogs.clear();
    }

    public int getCount()
    {
        return _blogs.size();
    }

    public BlogObject getItem(int position)
    {
        return _blogs.get(position);
    }

    public long getItemId(int postion)
    {
        return _blogs.get(postion).getpk();
    }


    /*
     * BlogObject
     */
    public class BlogObject extends Object
    {
        private long pk;
        private String title;
        private String content;

        public long getpk()
        {
            return pk;
        }

        public void setPk( long p )
        {
            this.pk = p;
        }

        public String getTitle()
        {
            return title;
        }

        public void setTitle( String st )
        {
            this.title = st;
        }

        public String getContent()
        {
            return this.content;
        }

        public void setContent( String s )
        {
            this.content = s;
        }
    }


    /*
     * UserObject
     */
    public class UserObject extends Object
    {
        private String      token;
        private long        userid;


        public long getUserid()
        {
            return this.userid;
        }

        public void setUserid(long uid)
        {
            this.userid = uid;
        }

        public String getToken()
        {
            return this.token;
        }

        public void setToken(String st)
        {
            this.token = st;
        }
    }
}
