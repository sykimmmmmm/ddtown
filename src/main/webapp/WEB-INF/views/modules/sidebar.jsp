<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript">
//사이드바 메뉴 기능
document.addEventListener('DOMContentLoaded', function() {
    const navItemsWithSubmenu = document.querySelectorAll('.emp-sidebar .emp-nav-item.has-submenu');
    navItemsWithSubmenu.forEach(item => {
        const arrow = item.querySelector('.submenu-arrow');
        item.addEventListener('click', function(event) {
            if (this.getAttribute('href') === '#') {
                event.preventDefault();
            }
            const parentLi = this.parentElement;
            const submenu = this.nextElementSibling;

            if (submenu && submenu.classList.contains('emp-submenu')) {
                const parentUl = parentLi.parentElement;
                if (parentUl) {
                    Array.from(parentUl.children).forEach(siblingLi => {
                        if (siblingLi !== parentLi) {
                            const siblingSubmenuControl = siblingLi.querySelector('.emp-nav-item.has-submenu.open');
                            if (siblingSubmenuControl) {
                                const siblingSubmenuElement = siblingSubmenuControl.nextElementSibling;
                                siblingSubmenuControl.classList.remove('open');
                                if (siblingSubmenuElement && siblingSubmenuElement.classList.contains('emp-submenu')) {
                                    siblingSubmenuElement.style.display = 'none';
                                }
                                const siblingArrow = siblingSubmenuControl.querySelector('.submenu-arrow');
                                if (siblingArrow) siblingArrow.style.transform = 'rotate(0deg)';
                            }
                        }
                    });
                }
            }
            
            this.classList.toggle('open');
            if (submenu && submenu.classList.contains('emp-submenu')) {
                submenu.style.display = this.classList.contains('open') ? 'block' : 'none';
                if (arrow) arrow.style.transform = this.classList.contains('open') ? 'rotate(90deg)' : 'rotate(0deg)';
            }
        });
    });

	// 현재 페이지 URL 기반으로 사이드바 메뉴 활성화
	const currentFullHref = window.location.href; 
	document.querySelectorAll('.emp-sidebar .emp-nav-item[href]').forEach(link => {
	    if (link.href === currentFullHref) {
	        link.classList.add('active');
	        let currentActiveElement = link;
	        while (true) {
	            const parentLi = currentActiveElement.parentElement;
	            if (!parentLi) break;
	            const parentSubmenuUl = parentLi.closest('ul.emp-submenu');
	            if (parentSubmenuUl) {
	                parentSubmenuUl.style.display = 'block';
	                const controllingAnchor = parentSubmenuUl.previousElementSibling;
	                if (controllingAnchor && controllingAnchor.classList.contains('has-submenu')) {
	                    controllingAnchor.classList.add('active', 'open');
	                    const arrow = controllingAnchor.querySelector('.submenu-arrow');
	                    if (arrow) arrow.style.transform = 'rotate(90deg)';
	                    currentActiveElement = controllingAnchor;
	                } else break;
	            } else break;
	        }
	    }
	});
});
</script>