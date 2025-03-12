package com.sajid.counter;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import com.sajid.counter.R;

public class MultiCounterWidgetProvider extends AppWidgetProvider {
    private static final String INCREMENT_ACTION = "com.sajid.counter.INCREMENT_ACTION";

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId);
        }
    }

    private void updateWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        int counter = prefs.getInt("counter_" + appWidgetId, 0); // Get specific counter

        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);
        views.setTextViewText(R.id.counterText, "Counter: " + counter);

        // Create intent to handle increment button click
        Intent intent = new Intent(context, WidgetClickReceiver.class);
        intent.setAction(INCREMENT_ACTION);
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
    PendingIntent pendingIntent = PendingIntent.getBroadcast(context, appWidgetId, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);


        // Set click listener
        views.setOnClickPendingIntent(R.id.incrementButton, pendingIntent);

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
}




// package com.sajid.counter;

// import android.appwidget.AppWidgetManager;
// import android.appwidget.AppWidgetProvider;
// import android.content.Context;
// import android.content.SharedPreferences;
// import android.widget.RemoteViews;

// import com.sajid.counter.R;

// public class MultiCounterWidgetProvider extends AppWidgetProvider {

//     @Override
//     public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
//         for (int appWidgetId : appWidgetIds) {
//             RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_layout);

//             // Read counter value from SharedPreferences
//             SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
//             int counter = prefs.getInt("counter", 0); // Default to 0 if not found

//             views.setTextViewText(R.id.counterText, "Counter: " + counter);
//             appWidgetManager.updateAppWidget(appWidgetId, views);
//         }
//     }
// }
