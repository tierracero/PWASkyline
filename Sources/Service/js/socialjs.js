//
//  socialjs.swift
//  
//
//  Created by Victor Cantu on 10/17/22.
//
function initfb(callback){
    
    window.fbAsyncInit = function() {
        
        FB.init({
            appId      : '338939433169924', // 338939433169924 481679727207994
            cookie     : true,
            xfbml      : true,
            version    : 'v3.3'
        });
        
        FB.AppEvents.logPageView();
        
        checkFBLoginState(callback)
        
    };

    (function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       js.src = "https://connect.facebook.net/en_US/sdk.js";
       fjs.parentNode.insertBefore(js, fjs);
     }(document, 'script', 'facebook-jssdk'));
}

function checkFBLoginState(callback) {
    FB.getLoginStatus(function(response) {
        console.log("⭐️ cheke  checkLoginState ")
        console.log(JSON.stringify(response))
        callback(JSON.stringify(response))
    });
}

/// pages_messaging,pages_manage_posts,pages_read_engagement,pages_show_list,instagram_basic,instagram_manage_comments,instagram_content_publish,pages_manage_metadata,pages_read_user_content,pages_manage_engagement
function loginfb(callback) {
    FB.login(function(response){
        checkFBLoginState(callback);
    }, {
        scope: 'pages_messaging,' +
        'pages_manage_posts,' +
        'pages_read_engagement,' +
        'pages_show_list,' +
        'pages_manage_metadata,' +
        'pages_read_user_content,' +
        'pages_manage_engagement,' +
        'instagram_basic,' +
        'instagram_manage_comments,' +
        'instagram_content_publish,' +
        'instagram_manage_messages' +
        'instagram_manage_insights',
        return_scopes: true
        
    });
}

function logoutfb(callback){
    FB.logout(function(response) {
        checkFBLoginState(callback);
  });
}

function goToURL(url){
    window.location = url
}
function openNewWindow(url){
    window.open(url, '_blank')
}
