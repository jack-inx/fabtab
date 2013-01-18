var lastRefreshTime = null;
var reloadUserAds = function(){
  var adsUrl = lastRefreshTime === null ? '/ads.json' : '/ads.json?modified_since=' + lastRefreshTime;
  $.get(adsUrl, function(data,textStatus,jqXHR){
    updateAdsByEveryone(data);
    lastRefreshTime = jqXHR.getResponseHeader('date');
  });
};

var top_carousel_refresh = function(){
  if ($('#optin_ads_carousel li:visible').length < 3 ) {
    $('#optin_ads_carousel li:hidden:first').show();
  }
  $('#optin_ads_pagination').remove();
  $('#optin_ads_carousel').easyPaginate({
page: 1,
    step: 3,
    controls: 'optin_ads_pagination',
temp: false
  });
};

var updateAdsByEveryone = function(ads) {
  if( ads.length > 0 ){
    for(var i=0; i< ads.length; i++ ){
      $("#saved_ads_carousel li[style*='list-item']:last").hide();
      var adDetails = $('.template').clone();
      adDetails.children('div').removeClass('hidden');
      adDetails.removeClass('template');
if (ads[i].status == true)
            {
      if ( ads[i].ad_type == 'video'){
        adDetails.find('.ad_image').append("<iframe src="+ ads[i].image_url +" width=216 height=180 border='none'></iframe>");
        adDetails.find('.ad_image img').hide();
      }else {
        adDetails.find('img')[0].src = ads[i].image_url;
      }
      adDetails.find('.site')[0].innerHTML = decodeURIComponent(ads[i].url).split('/')[2];
      adDetails.find('#url:first').val(function(){
        return ads[i].url;
      });
      adDetails.find('#ad_type:first').val(function(){
        return ads[i].ad_type;
      });
  adDetails.find('.flag-button:first').attr('id', ads[i].id);
                adDetails.find('.remove-button:first').attr('id', ads[i].id);

      if(ads[i].group.user){
        adDetails.find('.user span')[0].innerHTML = ads[i].group.user.nickname;
        $('#saved_ads_carousel').prepend(adDetails);
      }
    }
}
    $('#temp_pagination').remove();
    var paginate = $('#saved_ads_carousel').easyPaginate({
page: 1,
      step: 4,
      controls: 'temp_pagination',
temp: false
    });
    paginate.show();
  }
};


$(document).ready(function() {
  reloadUserAds();
  
  $.ajax({
    url: '/setting',
    type: 'GET',
    success: function(data, textStatus, xhr) {
        setInterval(reloadUserAds, data.carousel_refresh * 1000 );
    }
  });
  

  $(document).on({
    mouseenter: function(){
      $(this).find('.tabit-button:first').removeClass('hidden');
$(this).find('.flag-button:first').removeClass('hidden');
            $(this).find('.remove-button:first').removeClass('hidden');
    },
    mouseleave: function(){
      $(this).find('.tabit-button:first').addClass('hidden');
$(this).find('.flag-button:first').addClass('hidden');
            $(this).find('.remove-button:first').addClass('hidden');
    }
  },'#saved_ads_carousel li');

  $(document).on('click','#saved_ads_carousel li .tabit-button', function(){
    var self = this;
    $('.tabit_dialog').clone().appendTo($(self).parent());
    var dialog = $(self).parent().children('.tabit_dialog');
    dialog.removeClass('hidden');
    dialog.find('#ad_url').val(function(){
      return $(self).parent().find('.ad_details #url').val();
    });
    
    dialog.find('#ad_ad_type').val(function(){
      return $(self).parent().find('.ad_details #ad_type').val();
    });
    
    dialog.find('#ad_image_url').val(function(){
      if ( $(self).parent().find('iframe').length > 0){
        return $(self).parent().find('iframe').attr('src');
      }
      return $(self).parent().find('img').attr('src');
    });
    
    dialog.find('.tabit').click(function(){
      $.ajax({
        url: dialog.find('form:first').attr('action'),
        type: 'POST',
        data: dialog.find('form:first').serialize(),
        success: function(data,textStatus,jqXHR){
          var image_url = dialog.find('#ad_image_url').val();
          if ( $("#optin_ads_carousel .group[data-folder='"+ data + "']").length > 0 ){
            new MyFabTab.Folder("#optin_ads_carousel .group[data-folder='"+ data + "']").add(image_url,$('#ad_ad_type').val());
            $(self).parent().children('.tabit_dialog').remove();
            $(self).parent().find('.tabit-button:first').addClass('hidden');
          } else {
            location.reload();
          }
          return false;
        }
      });
      return false;
    });
    
    dialog.find('.cancel').click(function(event) {
      dialog.remove();
      $(self).addClass('hidden');
      return false;
    });
    
    return false;
  });
  
  $('#optin_ads_carousel li').hover(function() {
    $(this).children('.edit-button').removeClass('hidden');
  }, function() {
    $(this).children('.edit-button').addClass('hidden');
    $(this).children('.edit_dialog').addClass('hidden');
    $(this).find('.delete_dialog:first').addClass('hidden');
  });
  
  $('#optin_ads_carousel li .edit-button').click(function(event) {
    var self = this;
    var editDialog = $(self).parent().children('.edit_dialog');
    editDialog.removeClass('hidden');
    var action = editDialog.find('form:first').attr('action');
    editDialog.find('.save:first').click(function(){
      $.ajax({
        url: action ,
        type: 'PUT',
        data: editDialog.find('form:first').serialize(),
        success: function(data,textStatus,jqXHR) {
          if (data.new_group) {
            $(self).parent().remove();
            top_carousel_refresh();
          } else {
            $(self).parent().find('.folder-category:first').html(data.category);
            editDialog.find('form #category option:first').attr('selected',true);
          }
          $(self).parent().children('.edit_dialog').addClass('hidden');
          $(self).parent().children('.edit-button').addClass('hidden');
        }
      });
      return false;
    });
    
    editDialog.find('.delete').click(function() {
      editDialog.parent().find('.delete_dialog').removeClass('hidden');
      editDialog.parent().find('.delete_dialog .delete_folder').click(function(){
        $.ajax({
          url: action,
          type: 'DELETE',
          data: editDialog.find('form').serialize(),
          success: function(data, textStatus, xhr) {
            $(self).parent().remove();
            top_carousel_refresh();
          }
        });
        return false;
      });
      return false;
    });
    
    return false;
  });
  
});


