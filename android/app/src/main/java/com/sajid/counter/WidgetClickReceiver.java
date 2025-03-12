package com.sajid.counter;

import android.appwidget.AppWidgetManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

public class WidgetClickReceiver extends BroadcastReceiver {
    private static final String INCREMENT_ACTION = "com.sajid.counter.INCREMENT_ACTION";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (INCREMENT_ACTION.equals(intent.getAction())) {
            int appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1);
            if (appWidgetId != -1) {
                SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
                int counter = prefs.getInt("counter_" + appWidgetId, 0);

                counter++; // Increment counter

                // Save updated counter value
                prefs.edit().putInt("counter_" + appWidgetId, counter).apply();

                // Update the widget UI
                RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);
                views.setTextViewText(R.id.counterText, "Counter: " + counter);

                AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
                appWidgetManager.updateAppWidget(appWidgetId, views);
            }
        }
    }
}
