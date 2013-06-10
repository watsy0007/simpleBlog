package com.watsy.simpleblog;

import android.content.Intent;
import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.view.View;
import android.widget.*;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.view.LayoutInflater;
import android.content.Context;

import com.watsy.simpleblog.R;
import com.watsy.simpleblog.ActivityLogin;
import com.watsy.simpleblog.activity_addblog;


public class MainActivity extends Activity implements AnsycCallBack {


    TextView        _userMsg;
    Button          btnLogin;
    Button          btnAddBlog;
    ListView        _blogsView;
    BlogModel       blogs;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        _userMsg = (TextView)this.findViewById(R.id.txViewMsg);
        btnLogin = (Button)this.findViewById(R.id.btnLogin);
        btnAddBlog = (Button)this.findViewById(R.id.btnAddBlog);
        _blogsView = (ListView)this.findViewById(R.id.blogsView);

        blogs = new BlogModel("http://192.168.1.41:8001" , this);


        btnLogin.setOnClickListener( new loginClicked() );
        btnAddBlog.setOnClickListener( new addNewBlogClicked() );

        _blogsView.setAdapter(new BlogsAdapter());

        blogs.getblogs();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    //login
    public class loginClicked implements OnClickListener
    {
        public void onClick(View v)
        {
//            blogs.login( "watsy" , "258841679" );

            Intent intent = new Intent( MainActivity.this , ActivityLogin.class );

            ActivityLogin._blogModel = blogs;


            startActivity(intent);

            overridePendingTransition(R.anim.fade, R.anim.hold);
        }
    }

    //add new blog
    public class addNewBlogClicked implements OnClickListener
    {
        public void onClick(View v)
        {
//            blogs.addBlog( "I'm from android" , "##Hello android world!");

            Intent intent = new Intent( MainActivity.this, activity_addblog.class );
            activity_addblog._blogModel = blogs;

            startActivity( intent );

            overridePendingTransition(R.anim.fade, R.anim.hold);
        }
    }

    public void didFinished(String action, Object obj)
    {
        //login action
        if ( action.equals( BlogModel.API_ACTION_LOGIN ) )
        {
            System.out.print("=_= equal");
            _userMsg.setText( "watsy" );
        }

        else if ( action.equals( BlogModel.API_ACTION_GETBLOGS ) )
        {
            _blogsView.invalidateViews();
        }

        else if ( action.equals( BlogModel.API_ACTION_ADDBLOG ) )
        {
            blogs.reset();
            blogs.getblogs();
        }
    }
    public void didFailed(String action)
    {

    }


    public class BlogsAdapter extends BaseAdapter
    {


        public int getCount()
        {
            return blogs.getCount();
        }

        public View getView(int position, android.view.View convertView, android.view.ViewGroup parent)
        {

            LayoutInflater inflater = (LayoutInflater) MainActivity.this
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            // 使用View的对象itemView与R.layout.item关联
            View itemView = inflater.inflate(R.layout.item, null);


            TextView title = (TextView)itemView.findViewById(R.id.itemTitle);
            title.setText(blogs.getItem(position).getTitle());

            return itemView;
        }

        public long getItemId(int position)
        {
            return blogs.getItemId(position);
        }

        public Object getItem(int position)
        {
            return blogs.getItem(position);
        }

    }
}