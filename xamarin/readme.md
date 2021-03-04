
[set the app bar]
(https://developer.android.com/training/appbar/setting-up)



The Xamarin Android Designer
https://docs.microsoft.com/en-us/xamarin/android/user-interface/android-designer/designer-basics?tabs=windows


media picker to capture photo
https://docs.microsoft.com/en-us/xamarin/essentials/media-picker?context=xamarin%2Fandroid&tabs=android

data and cloud services

material theme
https://docs.microsoft.com/en-us/xamarin/android/user-interface/material-theme


Controls:
https://docs.microsoft.com/en-us/xamarin/android/user-interface/controls/


webview
https://docs.microsoft.com/en-us/xamarin/android/user-interface/controls/web-view


-- use Toast and add event handler with FindViewById method
 var b1 = FindViewById<Button>(Resource.Id.b1);

            b1.Click += (o, e) => {
               
                Toast.MakeText(this, "clicked", ToastLength.Short).Show();
            };


release through a website, APK
https://developer.android.com/studio/publish
https://docs.microsoft.com/en-us/xamarin/android/deploy-test/publishing/

