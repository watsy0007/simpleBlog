package com.watsy.simpleblog;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

/**
 * Created by watsy on 13-6-10.
 */



public class activity_addblog extends Activity
{

    public static BlogModel _blogModel;

    private EditText        _title;
    private EditText        _content;
    private Button          _addbtn;
    private Button          _cancelbtn;

    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_addblog);

        _title = (EditText)this.findViewById(R.id.addblog_title);
        _content = (EditText)this.findViewById(R.id.addblog_content);
        _addbtn = (Button)this.findViewById(R.id.addblog_addblog);
        _cancelbtn = (Button)this.findViewById(R.id.addblog_cancel);

        _addbtn.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                _blogModel.addBlog( _title.getText().toString() , _content.getText().toString() );
            }
        });

        _cancelbtn.setOnClickListener( new View.OnClickListener()
        {
            @Override
            public void onClick(View view)
            {
                activity_addblog.this.finish();
            }
        });
    }

}
