package com.github.ma1co.openmemories.tweak;

import android.app.Activity;
import android.content.Intent;
import android.view.KeyEvent;

public class BaseActivity extends Activity {
    @Override
    protected void onResume() {
        super.onResume();
        Logger.info("onResume", getComponentName().getShortClassName());
        notifyAppInfo();
    }

    @Override
    protected void onPause() {
        super.onPause();
        Logger.info("onPause", getComponentName().getShortClassName());
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            finish();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void notifyAppInfo() {
        Intent intent = new Intent("com.android.server.DAConnectionManagerService.AppInfoReceive");
        intent.putExtra("package_name", getComponentName().getPackageName());
        intent.putExtra("class_name", getComponentName().getClassName());
        sendBroadcast(intent);
    }
}
