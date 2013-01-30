
$(document).ready(function() {
      
    $('ul#saved_ads_carousel').easyPaginate({
        page: 1,
        step: 4,
        controls: 'temp_pagination',
        temp: false
    });
  
    $('ul#optin_ads_carousel').easyPaginate({
        page: 1,
        step: 3,
        controls: 'optin_ads_pagination',
        temp: false
    });
  
    $('ul#extra_offers_carousel').easyPaginate({
        page: 1,
        step: 3,
        controls: 'extra_offers_pagination',
        temp: false
    });
  
    $('ul#brand_ads_carousel').easyPaginate({
        page: 1,
        step: 3,
        controls: 'brand_ads_pagination',
        temp: false
    });
  
    $('ul#all_offers_carousel').easyPaginate({
        page: 1,
        step: 12,
        controls: 'all_offers_pagination',
        temp: false
    });
  
    $('#groups_carousel').easyPaginate({
        page: 1,
        step:12,
        controls: 'groups_pagination',
        temp: false
    });
  
    $('#folder_ads_carousel').easyPaginate({
        page: 1,
        step:12,
        controls: 'folder_ads_pagination',
        temp: false
    });
  
    $('.search .xinput').focusout(function(event) {
        $(this).attr('placeholder','search my fabtabs');
    });
  
    $('#adOptInForm').submit(function(){
        var form = $(this);
        $.ajax({
            type:'post',
            url:form.attr("action"),
            data: form.serialize(),
            success:function(data) {
                alert(data);
                $('.optindialog .input input').remove();
            },
            error: function(jqXHR, textStatus, errorThrown){
            },
            beforeSend: function(jqXHR, settings) {
                jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
            }
        });
    });
  
    $('#fabtabs_search .search .xinput').keyup(function(event) {
    
        if (event.keyCode == 40) {
            var focusElement = $('.predictive_results ul .result_focus');
            if( focusElement.length != 0){
                if (focusElement.next().length != 0 ){
                    focusElement.next().addClass('result_focus');
                    focusElement.removeClass('result_focus');
                }
            }else {
                if ( $('.predictive_results ul li').first().children('a').length > 0 ) {
                    $('.predictive_results ul li').first().addClass('result_focus');
                }
            }
            return false;
        }
    
        if( event.keyCode == 38 ){
            var focusElement = $('.predictive_results ul .result_focus');
            if( focusElement.length != 0 ){
                if ( focusElement ==  $('.predictive_results ul li').first() ){
                    $('#fabtabs_search .search .xinput').focus();
                    focusElement.removeClass('result_focus');
                } else {
                    focusElement.prev().addClass('result_focus');
                    focusElement.removeClass('result_focus');
                }
            }
            return false;
        }
    
        if(event.keyCode == 13 ) {
            var focusElement = $('.predictive_results ul .result_focus');
            if (focusElement.length > 0) {
                window.location.href = focusElement.children('a').attr('href');
            }
            return false;
        }
    
        if(event.keyCode == 27) {
            $(this).val("");
            new MyFabTab.SearchWidget('#fabtabs_search .search .results').remove();
        }
        
        if(event.keyCode == 8) {
            if ( $(this).val().length == 0 ) {
                $(this).val("");
                new MyFabTab.SearchWidget('#fabtabs_search .search .results').remove();
            }
        }
    
        if ( $(this).val().length > 2 ){
            $.get('/predictive_search',$(this).parents('#fabtabs_search').serialize(),function(data){
                new MyFabTab.SearchWidget('#fabtabs_search .search .results').update(data);
            });
        }
    
        return false;
    });
  
    $('#fabtabs_search').submit(function(){
        var results = $('.predictive_results ul li');
        if (results.children('a').length == 0 ) {
            return false;
        }
    });
    
      
    $('#createCategoryName').click(function(){
        $.post('/categories', $('#categoryName').serialize(), function(data){
            $('#category').append("<option value=" + data.id + " selected='true'>"+ data.name +"</option>");
            $('#categoryName').val("");
        });
    });

    $('#groupads').on({
        mouseenter: function() {
            $(this).find('.share').show();
            $(this).find('.delete').show();
            $(this).find('.move').show();
            $(this).find('.rate').show();
            $(this).find('.follow_brand').show();
        },
        mouseleave: function(){
            $(this).find('.share').hide();
            $(this).find('.delete').hide();
            $(this).find('.move').hide();
            $(this).find('.rate').hide();
            $(this).find('.follow_brand').hide();
            $(this).find('.delete_dialog').remove();
            $(this).find('.share_dialog').addClass('hidden');
            $(this).find('.rating_dialog').addClass('hidden');
            $(this).find('.follow_brand_dialog').remove();
      
        }
    },'#folder_ads_carousel li');

    $('#groupads').on('click','#folder_ads_carousel li .delete',function(){
        var link = this;
        $('.delete_dialog').clone().appendTo($(this).parent());
        var dialog = $(this).parent().find(".delete_dialog:first");
        dialog.removeClass('hidden');
        dialog.children('.delete_tab').click(function(){
            $.ajax({
                url: $(link).attr('href'),
                type: 'DELETE',
                success: function(data,textStatus,jqXHR){
                    $(link).parents('li:first').remove();
                    return false;
                }
            });
            return false;
        });
        return false;
    });
  
    $('#groupads').on('click','#folder_ads_carousel li .share',function(){
        var self = this;
        var dialog = $(self).parents('.options').find('.share_dialog').removeClass('hidden');
        return false;
    });
  
    $('#groupads').on('click','#folder_ads_carousel li .move',function(){
        var self = this;
        $('.move_dialog').clone().appendTo($(self).parent());
        var dialog = $(self).parent().children('.move_dialog');
        dialog.removeClass('hidden');
        dialog.find('form:first').attr('action',$(self).attr('href'));
        dialog.find('.save').click(function(){
            $.ajax({
                url: self.href,
                type: 'PUT',
                data: dialog.find('form:first').serialize(),
                success: function(data,textStatus,jqXHR) {
                    $(self).parents('li:first').remove();
                    return false;
                }
            });
            return false;
        });
    
        dialog.find('.cancel').click(function(event) {
            $(this).parents('.move_dialog:first').remove();
            return false;
        });
    
        return false;
    });
  
    $('#groupads').on('click','#folder_ads_carousel li .rate',function(){
        var self = this;
        $(self).parents('li').children('.rating_dialog').removeClass('hidden');
        return false;
    });
  
    $('#groupads').on('ajax:complete','#folder_ads_carousel li', function(xhr, status) {
        $(this).find(".ajaxful-rating-wrapper").replaceWith(status.responseText);
    });
  
    $('#groupads').on('click', '#folder_ads_carousel li .follow_brand',function(){
        var self = this;
        $('.follow_brand_dialog').clone().appendTo($(self).parent());
        var dialog = $(self).parent().find(".follow_brand_dialog:first");
        dialog.removeClass('hidden');
        dialog.find('.confirm_follower:first').click(function(event) {
            $.ajax({
                url: $(self).attr('href'),
                type: 'POST',
                success: function(data, textStatus, xhr) {
                    if ( data.location ) {
                        window.location.href = data.location;
                    }
                    updateFlashMessage(data,'success');
                    $(self).parents('li').find('.share:first').hide();
                    $(self).parents('li').find('.delete:first').hide();
                    $(self).parents('li').find('.move:first').hide();
                    $(self).parents('li').find('.rate:first').hide();
                    $(self).parents('li').find('.follow_brand:first').hide();
                    dialog.remove();
                }
            });
            return false;
        });
        return false;
    });
  
    $('.user-details div div .edit').click(function(event) {
        $(this).parent().children('.save').show();
        $(this).parent().children('.cancel').show();
        $(this).parent().find('.field .display_field').addClass('hidden');
        $(this).parent().find('.field .edit_field').removeClass('hidden');
        $(this).hide();
        return false;
    });
  
    $('.user-details div div .cancel').click(function(event) {
        $(this).parent().children('.edit').show();
        $(this).parent().find('.field .display_field').removeClass('hidden');
        $(this).parent().find('.field .edit_field input').val($(this).parent().find('.field .display_field').text());
        $(this).parent().find('.field .edit_field').addClass('hidden');
        $(this).parent().children('.save').hide();
        $(this).hide();
        return false;
    });
  
    $('#edit_user').submit(function(event) {
        var self = this;
        $.ajax({
            url: $(self).attr('action'),
            data: $(self).serialize(),
            type: 'PUT',
            success: function(data,textStatus,jqXHR){
                $(self).find('.field .edit_field').addClass('hidden');
                $(self).find('.field .display_field').removeClass('hidden');
                $(self).find('.save').hide();
                $(self).find('.cancel').hide();
                $(self).find('.edit').show();
                $(self).find('.name .field .display_field').text(data.full_name);
                $(self).find('.email .field .display_field').text(data.email);
                $(self).find('.username .field .display_field').text(data.username);
                $(self).find('.zipcode .field .display_field').text(data.zipcode);
                var div = "<div class='delete_dialog' style='margin-left: 69px ! important; margin-top: -335px ! important;'><div class='title' style='margin-left:15px;font-size:19px !important;margin-top:66px;'></div><div class='close234 close_dialog_offer'>X</div><div style='color: rgb(126, 190, 87); font-size: 23px; font-weight: bold; margin-left: 28px; margin-top: 83px;'>Successful!</div></div></br></br>";
                $('.Middle_Top').after(div);
                var mask = "<div id='mask_div' style='opacity:0.5;position: absolute;left:0; top:0;height:190%;width:100%;z-index: 50;background:#000;'></div>";
                $('body').after(mask);
                return false;
            }
        });
        return false;
    });
    
    $(".close234, #mask_div").live('click',function(){
        $(".delete_dialog").remove();
        $("#mask_div").remove();
    });

    $('.add_ad').click(function(event) {
        var self = this;
        var form = $(self).parent();
        $.ajax({
            url: form.attr('action'),
            type: 'POST',
            data: form.serialize(),
            success: function(data, textStatus, xhr) {
                $('#new_group').addClass('hidden');
            }
        });
    
        return false;
    });
  
    $('.offer_btn').click(function(event) {
        $('#new_group').addClass('hidden');
        $('#new_offer').removeClass('hidden');
        return false;
    });
  
    $('.ad_btn').click(function(event) {
        $('#new_offer').addClass('hidden');
        $('#new_group').removeClass('hidden');
        return false;
    });
  
    $('.save_settings').click(function(event) {
        var self = this;
        var form = $(self).parent();
        $.ajax({
            url: form.attr('action'),
            type: 'PUT',
            data: form.serialize(),
            success: function(data, textStatus, xhr) {
                $('.flash-message').addClass('success');
                $('.flash-message').text(data);
            },
            error: function(xhr, textStatus, errorThrown) {
                $('.flash-message').addClass('error');
                $('.flash-message').text(xhr.responseText);
            }
        });
        return false;
    });
    
    $('.addBrand').click(function() {
        var self = this;
        var form = $(self).parents('form');
        $.ajax({
            url: $(form).attr('action'),
            type: 'DELETE',
            data: form.serialize(),
            success: function(data, textStatus, xhr) {
                updateFlashMessage('The ad has been associated with the brand','success');
                $(self).parents('li').remove();
            }
        });
    
        return false;
    });
    
    $('#tabAds').click(function(event) {
        var self = this;
        $.ajax({
            url: $(self).parents('form').attr('action'),
            type: 'POST',
            data: $(self).parents('form').serialize(),
            success: function(data, textStatus, xhr) {

                if ($("input[@name=folder]:checked").val() == "brand")
                {

                    updateFlashMessage1('Offer saved to brand folder','success');
                }
                else
                {
                    updateFlashMessage1('Successfully tabbed!','success');
                }

                //                updateFlashMessage1('Successfully tabbed!','success');
                setTimeout(function() {
                    window.close();
                }, 10000);
            }
        });
        return false;
    });
  
    $('#groups_carousel li').hover(function() {
        $(this).children('.edit-buttons').removeClass('hidden');
    }, function() {
        $(this).children('.edit-buttons').addClass('hidden');
        $(this).children('.edit_dialog').addClass('hidden');
    });
    
    $('#groups_carousel li .edit-button').click(function(event) {
        var self = this;
        var editDialog = $(self).parent().children('.edit_dialog');
        $(self).parent().children().children().children('.delete_dialog').addClass('hidden');
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
                        group_carousel_refresh();
                    } else {
                        $(self).parent().find('.folder-category:first').html(data.category);
                        editDialog.find('form #category option:first').attr('selected',true);
                    }
                    $(self).parent().children('.edit_dialog').addClass('hidden');
                    $(self).parent().children('.edit_dialog').removeAttr('style');
                    $(self).parent().children('.edit-button').addClass('hidden');
                }
            });
            return false;
        });
    
        editDialog.find('.delete').click(function() {
            $.ajax({
                url: action,
                type: 'DELETE',
                data: editDialog.find('form').serialize(),
                success: function(data, textStatus, xhr) {
                    $(self).parent().remove();
                    group_carousel_refresh();
                }
            });
            return false;
        });
    
        return false;
    });
    
    
    $('.deleteBrand').click(function(event) {
        var self = this;
        var action = $(self).parent().attr('action');
        $.ajax({
            url: action,
            type: 'DELETE',
            success: function(data, textStatus, xhr) {
                $(self).parents('li:first').remove();
                updateFlashMessage(data,'success');
            }
        });
    
        return false;
    });
  
    $('.deleteDemo').click(function(event) {
        var self = this;
        var action = $(self).parent().attr('action');
        $.ajax({
            url: action,
            type: 'DELETE',
            success: function(data, textStatus, xhr) {
                $(self).parents('li:first').remove();
                updateFlashMessage(data,'success');
            }
        });
    
        return false;
    });
    
    $('.custom_code_btn').click(function(event) {
        var customCode = "&custom=" + decodeURIComponent($('#site_url').val()) + "&custom1=" + decodeURIComponent($('#image_url').val());
        $('#ad_custom_code').val(customCode);
        $('.image_url').hide();
        $('.site_url').hide();
        $('#image_url').hide();
        $('#site_url').hide();
        $(this).hide();
        $('.custom_code').show();
        $('#ad_custom_code').show();
        $('.adspeed_data').show();
        $('#demo_adspeed_data').show();
        $('#createDemo').show();
        return false;
    });
  
  
    $('#addAd').click(function() {
        $("#page").append($(".adWrapper"));
        $("#page .adWrapper").css('position','absolute');
        $("#page .adWrapper").css('left', function(){
            return $('#adLeft').val() + 'px';
        });
        $("#page .adWrapper").css('top', function(){
            return $('#adTop').val() + 'px';
        });
        $("#page .adWrapper").show();
        $("#page .adWrapper").draggable({
            drag: function(){
                var adPosition = $('#page .adWrapper').position();
                $('#position').val(adPosition.left + ',' + adPosition.top);
            }
        });
		
    });


	

    $('#my_folder').change(function(event) {
        //$('#my_folder').attr('checked',true);
        $('#brand_folder').attr('checked',false);
        $('#brandname').hide();
        $('.tabit_field').hide();
        $('#my_folder').attr('checked',true);
        return false;
    });

    $('#brand_folder').change(function(event) {
        $('#my_folder').attr('checked',false);
        $('#brand_folder').attr('checked',true);
        $('#brand_folder').attr('disabled',false);
        $('.tabit_field').show();
        $('#brandname').show();
        $('#my_folder').attr('checked',false);
        //   $('#my_folder').attr('disabled',true);
        return false;
    });

    $('#brand_ads_carousel li').hover(function() {
        $(this).children('.edit-button').removeClass('hidden');
    }, function() {
        $(this).children('.edit-button').addClass('hidden');
        $(this).children('.edit_dialog').addClass('hidden');
        $(this).find('.delete_dialog:first').addClass('hidden');
    });
  
    $('#brand_ads_carousel li .edit-button').click(function(event) {
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
  
    $('.delete-image').click(function(event) {
        var self = this;
        var form = $(self).parent();
        $.ajax({
            url: form.attr('action'),
            type: 'DELETE',
            data: form.serialize(),
            success: function(data, textStatus, xhr) {
                $(self).parents('li').remove();
                updateFlashMessage(data,'success');
            }
        });
    
        return false;
    });
  
});

var group_carousel_refresh = function(){
    if ($('#groups_carousel li:visible').length < 12 ) {
        $('#groups_carousel li:hidden:first').show();
    }
    $('#groups_pagination').remove();
    $('#groups_carousel').easyPaginate({
        step: 12,
        controls: 'groups_pagination'
    });
};

var folder_ads_carousel_refresh = function(){
    if ($('#folder_ads_carousel li:visible').length < 12 ) {
        $('#folder_ads_carousel li:hidden:first').show();
    }
    $('#folder_ads_pagination').remove();
    $('#folder_ads_carousel').easyPaginate({
        step: 12,
        controls: 'folder_ads_pagination'
    });
};


var updateFlashMessage = function(data,statusClass) {
    $('.flash_messages div').addClass(statusClass);
    $('.flash_messages div').text(data);
    $('.flash_messages').fadeIn(2000).delay(5000).fadeOut(5000);
};


var updateFlashMessage1 = function(data,statusClass) {
    $('.flash1_messages div').addClass(statusClass);
    $('.flash1_messages div').text(data);
    $('.flash1_messages').fadeIn(2000).delay(5000).fadeOut(5000);
};

var MyFabTab = {};

MyFabTab.Folder = function(selector){
    this.selector = selector;
};

MyFabTab.Folder.prototype.add = function(imageUrl,type){
    var imageDiv = document.createElement('div');
    imageDiv.setAttribute('class','image');
    var image = document.createElement('img');
    if( type == "video"){
        var dummyLink = document.createElement('a');
        dummyLink.href = imageUrl;
        var path = dummyLink.pathname.split('/');
        image.src = "http://img.youtube.com/vi/" + path[path.length-1] + "/0.jpg";
    } else {
        image.src = imageUrl;
    }
    image.setAttribute('class','folder-images');
    imageDiv.appendChild(image);
    allImages = $(this.selector).find('.folder .folder-content .image');
    if (allImages.length == 4 ) {
        allImages.last().remove();
    }
    $(this.selector).find('.folder .folder-content').prepend(imageDiv);
};

MyFabTab.SearchWidget = function(selector){
    this.selector = selector;
};

MyFabTab.SearchWidget.prototype.update = function(html){
    if (!$(this.selector).empty()) {
        this.remove();
    }
    $(this.selector).append(html);
};

MyFabTab.SearchWidget.prototype.remove = function(){
    $(this.selector).children().remove();
};
 
MyFabTab.Carousel = {};


function getUrlVars(src) {
    var vars = [], hash;
    var hashes = src.slice(src.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
  
    var splitUrl = vars[0].split('/');
    vars.push('id');
    vars['id'] = splitUrl[splitUrl.length-1];
  
    return vars;
}
$('ul#items').easyPaginate({
    step: 1,
    controls: 'saved_ads_pagination'
});


function flag(ad)
{
    var ad_id = $(ad).attr('id')
    $.ajax({
        type: "POST",
        url: "/ads/flags_ad/"+ad_id,
        dataType: "html",
        success: function(data) {
            updateFlashMessage('Successfully flagged!','success');
        }
    });
}

function remove(ad)
{
    var ad_id = $(ad).attr('id')
    $.ajax({
        type: "POST",
        url: "/ads/remove_ad/"+ad_id,
        dataType: "html",
        success: function(data) {
            window.location="/";
            updateFlashMessage('Successfully Deleted!','success');
        }
    });
}

function remove_offer(ad)
{
    var ad_id = $(ad).parent().prev().attr('id')
    $.ajax({
        type: "POST",
        url: "/ads/remove_ad/"+ad_id,
        dataType: "html",
        success: function(data) {
            window.location="/";
            updateFlashMessage('Successfully Deleted!','success');
        }
    });

}

function delete_alert_box(ad){
    $(this).click(function(event){
        event.preventDefault();
    });
    $(ad).next().attr('style','display:block;margin-top: -138px;margin-left:4px;')
    
}

$(".close").live('click',function(){
    $(this).parent().hide();
});
