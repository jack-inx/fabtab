/*
 * 	Easy Paginate 1.0 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/
 *
 *	Copyright (c) 2011 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */

(function($) {
		  
    $.fn.easyPaginate = function(options){

        var defaults = {
            step: 1,
            delay: 0,
            numeric: true,
            nextprev: true,
            auto:false,
            pause:4000,
            clickstop:true,
            controls: 'pagination',
            current: 'current'
        };
		
        var options = $.extend(defaults, options);
        var step = options.step;
        var lower, upper;
        var children = $(this).children();
        var count = children.length;
        var obj, next, prev;
        var page = options.page;
        var timeout;
        var clicked = false;
        var menu_status = options.temp

        function show(){
            clearTimeout(timeout);
            lower = ((page-1) * step);
            upper = lower+step;
            $(children).each(function(i){
                var child = $(this);
                child.hide();
                if(i>=lower && i<upper){
                    setTimeout(function(){
                        child.fadeIn('fast')
                    }, ( i-( Math.floor(i/step) * step) )*options.delay );
                }
                if(options.nextprev){
                    if(upper >= count) {
                        next.fadeOut('fast');
                    } else {
                        next.fadeIn('fast');
                    };
                    if(lower >= 1) {
                        prev.fadeIn('fast');
                    } else {
                        prev.fadeOut('fast');
                    };
                };
            });
            $('li','#'+ options.controls).removeClass(options.current);
            $('li[data-index="'+page+'"]','#'+ options.controls).addClass(options.current);
			
            if(options.auto){
                if(options.clickstop && clicked){}else{
                    timeout = setTimeout(auto,options.pause);
                };
            };
            if(menu_status)
            {
                if(page == 1)
                {
                    $('.Header .Menu li.forth-item').removeClass('new_active');
                    $('.Header .Menu li.second-item').removeClass('new_active');
                    $('.Header .Menu li.third-item').removeClass('new_active');
                    $('.Header .Menu li.fifth-item').removeClass('new_active');
                    $('.Header .Menu li.sixth-item').removeClass('new_active');
                    $('.first-item').addClass('new_active');
                }
                else if(page == 2){
                    $('.Header .Menu li a.active').removeClass('active');
                    $('.Header .Menu li.forth-item').removeClass('new_active');
                    $('.Header .Menu li.third-item').removeClass('new_active');
                    $('.Header .Menu li.fifth-item').removeClass('new_active');
                    $('.Header .Menu li.first-item').removeClass('new_active');
                    $('.Header .Menu li.sixth-item').removeClass('new_active');
                    $('.second-item').addClass('new_active');
                }
                else if(page == 3){
                    $('.Header .Menu li a.active').removeClass('active');
                    $('.Header .Menu li.second-item').removeClass('new_active');
                    $('.Header .Menu li.forth-item').removeClass('new_active');
                    $('.Header .Menu li.first-item').removeClass('new_active');
                    $('.Header .Menu li.fifth-item').removeClass('new_active');
                    $('.Header .Menu li.sixth-item').removeClass('new_active');
                    $('.third-item').addClass('new_active');
                }
                else if(page == 4){
                    $('.Header .Menu li a.active').removeClass('active');
                    $('.Header .Menu li.third-item').removeClass('new_active');
                    $('.Header .Menu li.second-item').removeClass('new_active');
                    $('.Header .Menu li.first-item').removeClass('new_active');
                    $('.Header .Menu li.fifth-item').removeClass('new_active');
                    $('.Header .Menu li.sixth-item').removeClass('new_active');
                    $('.forth-item').addClass('new_active');
                }
                else if(page == 5){
                    $('.Header .Menu li a.active').removeClass('active');
                    $('.Header .Menu li.forth-item').removeClass('new_active');
                    $('.Header .Menu li.second-item').removeClass('new_active');
                    $('.Header .Menu li.third-item').removeClass('new_active');
                    $('.Header .Menu li.first-item').removeClass('new_active');
                    $('.Header .Menu li.sixth-item').removeClass('new_active');
                    $('.fifth-item').addClass('new_active');
                }
                else if(page == 6){
                    $('.Header .Menu li.forth-item').removeClass('new_active');
                    $('.Header .Menu li.second-item').removeClass('new_active');
                    $('.Header .Menu li.third-item').removeClass('new_active');
                    $('.Header .Menu li.fifth-item').removeClass('new_active');
                    $('.Header .Menu li.first-item').removeClass('new_active');
                    $('.sixth-item').addClass('new_active');
                }
					
            }
        };
		
        function auto(){
            if(upper <= count){
                page++;
                show();
            }
        };
		
        this.each(function(){
			
            obj = this;
			
            if(count>step){
			
				
				
                var pages = Math.floor(count/step);
                if((count/step) > pages) pages++;
				
                var ol = $('<ol id="'+ options.controls +'"></ol>').insertAfter(obj);
				
                if(options.nextprev){
                    prev = $('<li class="prev">Previous</li>')
                    .hide()
                    .appendTo(ol)
                    .click(function(){
                        clicked = true;
                        page--;
                        show();
                    });
                };
				
                if(options.numeric){
                    for(var i=1;i<=pages;i++){
                        $('<li data-index="'+ i +'">'+ i +'</li>')
                        .appendTo(ol)
                        .click(function(){
                            clicked = true;
                            page = $(this).attr('data-index');
                            show();
                        });
                    };
                };
				
                if(options.nextprev){
                    next = $('<li class="next">Next</li>')
                    .hide()
                    .appendTo(ol)
                    .click(function(){
                        clicked = true;
                        page++;
                        show();
                    });
                };
			
                show();
            };
        });
        return this;
    };

})(jQuery);
