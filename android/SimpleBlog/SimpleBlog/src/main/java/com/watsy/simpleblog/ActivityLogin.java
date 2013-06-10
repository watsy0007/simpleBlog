package com.watsy.simpleblog;

/**
 * Created by watsy on 13-6-10.
 */
import android.os.Bundle;
import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import com.watsy.simpleblog.BlogModel;

public class ActivityLogin extends Activity
{

    public static BlogModel _blogModel;

    private EditText        _username;
    private EditText        _password;
    private Button          _btnLogin;
    private Button          _btnCancel;

    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);


        _username = (EditText) findViewById(R.id.username);
        _password = (EditText) this.findViewById(R.id.password);
        _btnLogin = (Button) this.findViewById(R.id.btnLogin);
        _btnLogin.setOnClickListener( new loginClick() );

        _btnCancel = (Button) this.findViewById(R.id.btnCancel);

        _btnCancel.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ActivityLogin.this.finish();
            }
        });

    }

    protected class loginClick implements View.OnClickListener
    {
        public  void onClick(View v)
        {
            _blogModel.login( _username.getText().toString() , _password.getText().toString() );
        }
    }


}
