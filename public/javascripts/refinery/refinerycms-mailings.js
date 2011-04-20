$(function() {
	var nav = $('#mailings_navigation');
	if (nav.length > 0) {
  	$('li a[href$="' + window.location.pathname + '"]', nav).parent().addClass('selected');
		
		$('li.collapsible_menu').each(function() {
			var $li = $(this),
			    $menu = $('ul.submenu', $li);
					
			$('<span class="arrow">&nbsp;</span>').appendTo($li);
			
			if($('li.selected', $li).length > 0) {
				$li.addClass('open');
			} else {
				$li.addClass('closed');
				$menu.hide();
			}
			
			$('a:first', $li).click(function(e) {
				$li.toggleClass('open');
        $li.toggleClass('closed');
				$menu.animate({ opacity: 'toggle', height: 'toggle'}, 250);
				e.preventDefault();
			});
			
		});
		
  }
	var subscribers = $('#subscribers');
	if(subscribers.length > 0) {
		$('a.edit', subscribers).live('click', function() {
			$(this).parent().parent().find('form').toggle();
			return false;
		});
	}
	
});
