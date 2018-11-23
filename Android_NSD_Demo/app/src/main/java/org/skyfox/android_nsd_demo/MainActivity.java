package org.skyfox.android_nsd_demo;

import android.app.Activity;
import android.net.nsd.NsdServiceInfo;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends Activity {
    Button serverCreate;
    Button serverStart;
    Button serverStop;

    Button clientCreate;
    Button clientStart;
    Button clientStop;

    SFBonjourServer server;
    SFBonjourClient client;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



        serverCreate = (Button)findViewById(R.id.serverCreate);
        serverCreate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                server = new SFBonjourServer(MainActivity.this,"local.","dlna","SFBonjourServer",2333);
            }
        });

        serverStart = (Button)findViewById(R.id.serverStart);
        serverStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                server.start();
            }
        });

        serverStop = (Button)findViewById(R.id.serverStop);
        serverStop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                server.stop();
            }
        });


        clientCreate = (Button)findViewById(R.id.clientCreate);
        clientCreate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                client = new SFBonjourClient(MainActivity.this,"local.","dlna");

            }
        });

        clientStart = (Button)findViewById(R.id.clientStart);
        clientStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                client.start();
            }
        });

        clientStop = (Button)findViewById(R.id.clientStop);
        clientStop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                client.stop();
            }
        });
    }



}
