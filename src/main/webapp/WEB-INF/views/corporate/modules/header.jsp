<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="site-header" style="background: rgba(0, 0, 0, 0.50); backdrop-filter: blur(10px); border-bottom: 1px solid rgba(102, 126, 234, 0.2); position: fixed; top: 0; width: 100%; z-index: 1000; transition: all 0.3s ease; font-size: large;">
    <div class="header-container container" style="display: flex; align-items: center; justify-content: space-between; padding: 15px 20px;">
        <div class="logo">
            <h1 style="margin: 0;">
                <a href="${pageContext.request.contextPath}/corporate/main" 
                   style="font-size: 1.8rem; font-weight: 900; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-decoration: none; transition: all 0.3s ease;">
                   DD TOWN
                </a>
            </h1>
        </div>
        <nav class="main-nav">
            <ul style="display: flex; list-style: none; margin: 0; padding: 0; gap: 40px; align-items: center;">
                <li class="has-submenu" style="position: relative;">
                    <a href="${pageContext.request.contextPath}/corporate/finance" 
                       style="color: white; text-decoration: none; font-weight: 500; padding: 10px 0; transition: all 0.3s ease; display: flex; align-items: center; gap: 5px;">
                       기업 정보 <i class="fas fa-chevron-down" style="font-size: 0.8rem; transition: transform 0.3s ease;"></i>
                    </a>
                    <ul class="submenu" style="display: none; position: absolute; top: 100%; left: 0; background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); min-width: 200px; box-shadow: 0 10px 40px rgba(0,0,0,0.15); border-radius: 12px; padding: 12px 0; border: 1px solid rgba(102, 126, 234, 0.2); animation: fadeInUp 0.3s ease;">
                        <li><a href="${pageContext.request.contextPath}/corporate/about" 
                               style="display: block; padding: 12px 20px; color: #333; text-decoration: none; transition: all 0.3s ease; font-weight: 500;">기업소개</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/finance" 
                               style="display: block; padding: 12px 20px; color: #333; text-decoration: none; transition: all 0.3s ease; font-weight: 500;">재무정보</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/location" 
                               style="display: block; padding: 12px 20px; color: #333; text-decoration: none; transition: all 0.3s ease; font-weight: 500;">기업위치</a></li>
                        <li><a href="${pageContext.request.contextPath}/corporate/notice/list" 
                               style="display: block; padding: 12px 20px; color: #333; text-decoration: none; transition: all 0.3s ease; font-weight: 500;">기업공지</a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/corporate/audition/schedule" 
                       style="color: white; text-decoration: none; font-weight: 500; padding: 10px 0; transition: color 0.3s ease;">오디션</a></li>
                <li><a href="${pageContext.request.contextPath}/corporate/artist/profile" 
                       style="color: white; text-decoration: none; font-weight: 500; padding: 10px 0; transition: color 0.3s ease;">아티스트 프로필</a></li>
                <li><a href="${pageContext.request.contextPath}/community/main" 
                       style="color: white; text-decoration: none; font-weight: 500; padding: 10px 0; transition: color 0.3s ease;">아티스트 커뮤니티</a></li>
            </ul>
        </nav>
    </div>
    
    <style>
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .has-submenu:hover .submenu {
            display: block !important;
        }
        
        .has-submenu:hover i {
            transform: rotate(180deg);
        }
        
        .submenu a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            color: white !important;
            transform: translateX(5px);
        }
        
        .main-nav a:hover {
            color: #667eea !important;
        }
        
        /* Mobile responsive */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 20px;
            }
            
            .main-nav ul {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }
            
            .submenu {
                position: static !important;
                box-shadow: none !important;
                background: transparent !important;
                backdrop-filter: none !important;
                border: none !important;
                padding-left: 20px !important;
                margin-top: 10px !important;
            }
            
            .submenu a {
                color: rgba(255, 255, 255, 0.8) !important;
                padding: 8px 0 !important;
            }
            
            .submenu a:hover {
                color: #667eea !important;
                background: none !important;
                transform: none !important;
            }
        }
    </style>
</header>