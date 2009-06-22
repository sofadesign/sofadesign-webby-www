(function($) {
 
  $.fn.tumblr = function(o){
    var s = {
      username: ["sofadesign"],       // [string]   required, unless you want to display our posts. :) 
      count: 3,                       // [integer]  how many posts to display?
      intro_text: null,               // [string]   do you want text BEFORE your your posts?
      outro_text: null,               // [string]   do you want text AFTER your posts?
      join_text:  ' &gt; ',           // [string]   optional text in between date and post
      loading_text: null              // [string]   optional loading text, displayed while posts load
    };
    
    function truncate(str, length, ellipse)
    {
       if(ellipse == undefined) ellipse = "…";
       if(str.length <= length) return str;
       return str.substring(0, length - 1) + ellipse;
    }
    
    function stripHtmlTags(str)
    {
       var regexp = /<("[^"]*"|'[^']*'|[^'">])*>/gi;
       return str.replace(regexp, '');
    };

    if(o) $.extend(s, o);
    return this.each(function(){
      var list = $('<ul class="tumblr_list">').appendTo(this);
      var intro = '<p class="tumblr_intro">'+s.intro_text+'</p>'
      var outro = '<p class="tumblr_outro">'+s.outro_text+'</p>'
      var loading = $('<p class="loading">'+s.loading_text+'</p>');

      var query = 'num='+s.count; // TODO adding more options
      query += '&callback=?';
      var url = 'http://'+s.username+'.tumblr.com/api/read/json?'+query;
      
      if (s.loading_text) $(this).append(loading);
      //console.debug(123);
      $.getJSON(url, function(data){
        if (s.loading_text) loading.remove();
        if (s.intro_text) list.before(intro);
        $.each(data.posts, function(i,item){
          var join_text = s.join_text;
          var join_template = '<span class="tumblr_join"> '+join_text+' </span>';
          var join = (s.join_text) ? join_template : ' ';
          var date = '';
          var p_date = new Date(item.date);
          var day = new String(p_date.getDate());
          if(day < 10) day = "0" + day;
          date +=  day + "/" + p_date.getMonth();
          
          var title = '';
          var type = item.type;
          switch(type)
          {
             case 'regular':
             title = item['regular-title'];
             break;
             
             case 'photo':
             title = item['photo-caption'] == '' ? 'New photo.' : item['photo-caption'];
             break;
              
             case 'video':
             title = item['video-caption'] == '' ? 'New video.' : item['video-caption'];
             break;
             
             case 'audio':
             title = item['audio-caption'] == '' ? 'New audio.' : item['audio-caption'];
             break;
             
             case 'conversation':
             title = item['conversation-title'] == '' ? 'New conversation.' : item['conversation-title'];
             break;
             
             case 'link':
             title = item['link-text'];
             break;
             
             case 'quote':
             title = item['quote-text'];
             break;
          }
          
          title = $('<textarea/>').html(stripHtmlTags(title)).val();

          var text = '<span class="tumblr_text">';
          text += '<a href="'+item.url+'" title="view post on tumblr">';
          text += truncate( title, 90 ) + '</a>';
          text += '</span>';

          list.append('<li>' + date + join + text + '</li>');

          list.children('li:first').addClass('first');
          list.children('li:odd').addClass('even');
          list.children('li:even').addClass('odd');
        });
        if (s.outro_text) list.after(outro);
      });

    });
  };
})(jQuery);