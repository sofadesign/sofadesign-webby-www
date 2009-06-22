$(document).ready(function($) {
   if($.fn.supersleight != undefined)
   {
     $('#logo').supersleight({shim: 'http://www.sofa-design.net/img/x.gif'});
   };
 
   /* open external links in a new window */
   $('a[rel="external"], a[href^=http]').each(function(){
      if(this.href.indexOf(location.hostname) == -1) { 
         if(this.href.indexOf('sofadesign.tumblr.com') == -1 &&
            this.href.indexOf('www.sofa-design.net') == -1)
         {
            $(this).attr('target', '_blank');
         }
      }
   });
 
   if($('#slideshow').length > 0)
   {
     $('#slideshow').innerfade({
   	  speed: 'slow',
   	  timeout: 2800,
   	  type: 'random',
   	  containerheight: '170px'
   	});
   }
 
   if($('#tumblr-posts').length > 0)
   {
     $("#tumblr-posts").tumblr({
       join_text: " &gt; ",
       username: "sofadesign",
       count: 5,
       loading_text: "loading posts..."
     });
   };
 
   $.gaTracker('UA-1022900-3'); // ga tracker number...
});