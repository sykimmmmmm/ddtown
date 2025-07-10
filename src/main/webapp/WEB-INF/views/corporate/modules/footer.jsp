<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<footer class="site-footer">
    <div class="container">
        <div class="footer-container">
            <div class="footer-info">
                <div class="footer-logo">DDTOWN</div>
                <p class="footer-description">
                    DDTOWN은 창의성과 열정을 바탕으로 아티스트와 팬 모두에게 최고의 경험을 선사합니다. 
                    우리는 혁신적인 콘텐츠와 글로벌 네트워크를 통해 K-Culture의 미래를 만들어갑니다.
                </p>
                <div class="footer-contact">
                    <div class="contact-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>대전광역시 중구 계룡로 846, 3층 305호 DDTOWN</span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-phone"></i>
                        <span>042-222-8202</span>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-envelope"></i>
                        <span>ddtown305@gmail.com</span>
                    </div>
                </div>
            </div>
            <div class="footer-links">
                <h3>바로가기</h3>
                <ul>
                    <li class="has-submenu">
                        <a href="#">기업 정보</a>
                        <ul class="submenu">
                            <li><a href="${pageContext.request.contextPath}/corporate/about">기업소개</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/finance">재무정보</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/location">기업위치</a></li>
                            <li><a href="${pageContext.request.contextPath}/corporate/notice/list">기업공지</a></li>
                        </ul>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/corporate/audition/schedule">오디션</a></li>
                    <li><a href="${pageContext.request.contextPath}/corporate/artist/profile">아티스트 프로필</a></li>
                    <li><a href="${pageContext.request.contextPath}/community/artist/main">아티스트 커뮤니티</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 DDTOWN Entertainment. All Rights Reserved.</p>
        </div>
    </div>
    
    <style>
        /* Enhanced Footer Styles */
        .site-footer {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: white;
            padding: 80px 0 30px;
            position: relative;
            overflow: hidden;
        }
        
        .site-footer:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="footerPattern" width="40" height="40" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="1" fill="white" opacity="0.05"/><circle cx="10" cy="10" r="0.5" fill="white" opacity="0.03"/><circle cx="30" cy="30" r="0.5" fill="white" opacity="0.03"/></pattern></defs><rect width="100" height="100" fill="url(%23footerPattern)"/></svg>');
            pointer-events: none;
        }
        
        .footer-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 60px;
            margin-bottom: 50px;
            position: relative;
            z-index: 1;
        }
        
        .footer-info {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .footer-logo {
            font-family: 'Montserrat', sans-serif;
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            text-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
            letter-spacing: -1px;
        }
        
        .footer-description {
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 1.1rem;
            line-height: 1.8;
            color: rgba(255, 255, 255, 0.8);
            max-width: 500px;
            font-weight: 400;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .footer-contact {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 20px;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
            font-family: 'Noto Sans KR', sans-serif;
            font-weight: 500;
        }
        
        .contact-item:hover {
            background: rgba(102, 126, 234, 0.15);
            border-color: rgba(102, 126, 234, 0.3);
            transform: translateX(5px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
        }
        
        .contact-item i {
            font-size: 1.2rem;
            color: #667eea;
            width: 20px;
            text-align: center;
            filter: drop-shadow(0 2px 4px rgba(102, 126, 234, 0.3));
        }
        
        .contact-item span {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            transition: color 0.3s ease;
        }
        
        .contact-item:hover span {
            color: white;
        }
        
        .footer-links {
            position: relative;
        }
        
        .footer-links h3 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .footer-links h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2px;
        }
        
        .footer-links ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .footer-links > ul > li {
            margin-bottom: 15px;
        }
        
        .footer-links a {
            font-family: 'Noto Sans KR', sans-serif;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-weight: 500;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: block;
            padding: 8px 0;
            position: relative;
        }
        
        .footer-links > ul > li > a {
            font-weight: 600;
            font-size: 1.1rem;
        }
        
        .footer-links a:hover {
            color: #667eea;
            transform: translateX(5px);
        }
        
        .footer-links a:before {
            content: '';
            position: absolute;
            left: -15px;
            top: 50%;
            transform: translateY(-50%);
            width: 0;
            height: 2px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s ease;
        }
        
        .footer-links a:hover:before {
            width: 10px;
        }
        
        /* Enhanced Submenu Styles */
        .footer-links .has-submenu {
            position: relative;
        }
        
        .footer-links .submenu {
            position: static;
            background: transparent;
            box-shadow: none;
            padding-left: 25px;
            margin-top: 15px;
            border-left: 2px solid rgba(102, 126, 234, 0.3);
            padding-top: 10px;
        }
        
        .footer-links .submenu li {
            margin-bottom: 10px;
        }
        
        .footer-links .submenu a {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.95rem;
            font-weight: 400;
            padding: 6px 0;
        }
        
        .footer-links .submenu a:hover {
            color: #764ba2;
            background: none;
        }
        
        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 30px;
            text-align: center;
            position: relative;
            z-index: 1;
        }
        
        .footer-bottom p {
            font-family: 'Montserrat', sans-serif;
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.95rem;
            font-weight: 400;
            margin: 0;
            letter-spacing: 0.5px;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .site-footer {
                padding: 60px 0 20px;
            }
            
            .footer-container {
                grid-template-columns: 1fr;
                gap: 40px;
                margin-bottom: 30px;
            }
            
            .footer-logo {
                font-size: 2.5rem;
                text-align: center;
            }
            
            .footer-description {
                text-align: center;
                max-width: 100%;
            }
            
            .footer-contact {
                gap: 15px;
            }
            
            .contact-item {
                padding: 12px 15px;
                font-size: 0.95rem;
            }
            
            .footer-links {
                text-align: center;
            }
            
            .footer-links h3:after {
                left: 50%;
                transform: translateX(-50%);
            }
        }
        
        /* Animation for footer elements */
        @keyframes footerFadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .footer-info,
        .footer-links {
            animation: footerFadeIn 0.8s ease forwards;
        }
        
        .footer-links {
            animation-delay: 0.2s;
        }
    </style>
</footer>