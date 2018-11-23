package org.skyfox.android_nsd_demo;

import android.content.Context;
import android.net.nsd.NsdManager;
import android.net.nsd.NsdServiceInfo;
import android.os.StrictMode;
import android.util.Log;

import java.net.InetAddress;
import java.net.UnknownHostException;

public class SFBonjourServer {

    Context mContext;
    NsdManager mNsdManager;
    NsdServiceInfo mService;

    public static final String SFBonjourDefaultType = "_SFBonjour._tcp.";
    public static final String TAG = "SFBonjourServer";


    String mDomain;
    String mType;
    String mName;
    int mPort;

    public final static InetAddress LOCALHOST;
    static {
        // Because test.
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        InetAddress _host = null;
        try {
            _host = InetAddress.getLocalHost();
        } catch (UnknownHostException e) { }
        LOCALHOST = _host;
    }

    NsdManager.RegistrationListener mRegistrationListener;

    public SFBonjourServer(Context context) {
        mContext = context;
        mNsdManager = (NsdManager) context.getSystemService(Context.NSD_SERVICE);
    }
    public SFBonjourServer(Context context,String domain,String type,String name,int port) {
        mContext = context;
        mNsdManager = (NsdManager) context.getSystemService(Context.NSD_SERVICE);
        mDomain = domain;
        mType = "_" + type +"._tcp.";
        mName = name;
        mPort = port;
    }
    public void start(){
        mService  = new NsdServiceInfo();
        mService.setPort(mPort);
        mService.setServiceName(mName);
        mService.setServiceType(mType);
        mService.setHost(LOCALHOST);
        mRegistrationListener = new NsdManager.RegistrationListener() {
            @Override
            public void onRegistrationFailed(NsdServiceInfo nsdServiceInfo, int i) {
                Log.d(TAG,"onRegistrationFailed");
            }

            @Override
            public void onUnregistrationFailed(NsdServiceInfo nsdServiceInfo, int i) {
                Log.d(TAG,"onUnregistrationFailed");

            }

            @Override
            public void onServiceRegistered(NsdServiceInfo nsdServiceInfo) {
                Log.d(TAG,"onServiceRegistered");

            }

            @Override
            public void onServiceUnregistered(NsdServiceInfo nsdServiceInfo) {
                Log.d(TAG,"onServiceUnregistered");

            }
        };
        mNsdManager.registerService(
                mService, NsdManager.PROTOCOL_DNS_SD, mRegistrationListener);
    }
    public void stop(){
        mNsdManager.unregisterService(mRegistrationListener);

    }
}
