<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Knowledge Base - Enterprise Helpdesk</title>
    <meta name="description" content="Search the IT Knowledge Base for self-service guides, troubleshooting steps, and how-to articles.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/knowledge-base.css?v=1.0">
</head>
<body class="kb-body">

    <!-- Topbar -->
    <header class="kb-topbar">
        <a href="${pageContext.request.contextPath}/KnowledgeBase" class="kb-brand">
            <div class="kb-logo-badge">
                <i class="fas fa-book-open"></i>
            </div>
            <div>
                <div class="kb-brand-title">Knowledge Base</div>
                <div class="kb-brand-sub">IT Self-Service Portal</div>
            </div>
        </a>

        <div class="kb-topbar-actions">
            <c:choose>
                <c:when test="${sessionScope.role == 'Admin'}">
                    <a href="${pageContext.request.contextPath}/AdminDashboard" class="btn-topbar btn-outline-top">
                        <i class="fas fa-arrow-left"></i> Admin Dashboard
                    </a>
                    <button type="button" class="btn-topbar btn-primary-top" onclick="openAddArticleModal()">
                        <i class="fas fa-plus"></i> Add Article
                    </button>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/EmployeeDashboard" class="btn-topbar btn-outline-top">
                        <i class="fas fa-arrow-left"></i> My Portal
                    </a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/Logout" class="btn-topbar btn-outline-top" title="Sign Out">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </header>

    <!-- Hero Search Section -->
    <section class="kb-hero">
        <div class="kb-hero-inner">
            <div class="kb-hero-tag">
                <i class="fas fa-lightbulb"></i> Self-Service Knowledge Center
            </div>
            <h1 class="kb-hero-title">
                How can we <span>help you today?</span>
            </h1>
            <p class="kb-hero-subtitle">
                Browse guides, troubleshooting steps, and how-to articles from the IT Support team.
            </p>

            <form action="${pageContext.request.contextPath}/KnowledgeBase" method="GET" class="kb-search-bar">
                <i class="fas fa-search"></i>
                <input
                    type="text"
                    name="q"
                    class="kb-search-input"
                    id="heroSearchInput"
                    placeholder="Search articles, guides, troubleshooting tips..."
                    value="${fn:escapeXml(searchKeyword)}"
                    autocomplete="off"
                >
                <c:if test="${not empty selectedCategory && selectedCategory != 'all'}">
                    <input type="hidden" name="cat" value="${selectedCategory}">
                </c:if>
                <button type="submit" class="kb-search-btn">Search</button>
            </form>
        </div>
    </section>

    <!-- Stats Bar -->
    <div class="kb-stats-bar">
        <div class="kb-stat-item">
            <i class="fas fa-file-alt"></i>
            <span><strong>${fn:length(articles)}</strong> articles found</span>
        </div>
        <div class="kb-stat-item">
            <i class="fas fa-tags"></i>
            <span>Categories: Network, Software, Account, Hardware, Security</span>
        </div>
        <div class="kb-stat-item">
            <i class="fas fa-clock"></i>
            <span>Updated regularly by IT Support</span>
        </div>
    </div>

    <!-- Toast Notifications -->
    <c:if test="${param.added == 'true'}">
        <div class="kb-toast">
            <div class="kb-toast-inner kb-toast-success">
                <i class="fas fa-check-circle"></i> Article successfully added to the Knowledge Base.
            </div>
        </div>
    </c:if>
    <c:if test="${param.deleted == 'true'}">
        <div class="kb-toast">
            <div class="kb-toast-inner kb-toast-delete">
                <i class="fas fa-trash-alt"></i> Article has been removed.
            </div>
        </div>
    </c:if>

    <!-- Main Layout -->
    <div class="kb-main-layout">

        <!-- Category Sidebar -->
        <nav class="kb-category-nav">
            <div class="kb-nav-title">Browse by Category</div>

            <a href="${pageContext.request.contextPath}/KnowledgeBase${not empty searchKeyword ? '?q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'all' || empty selectedCategory ? 'active' : ''}">
                <i class="fas fa-th-large"></i>
                All Articles
                <span class="kb-cat-count">${fn:length(articles)}</span>
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Network+%26+VPN${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Network & VPN' ? 'active' : ''}">
                <i class="fas fa-wifi"></i>
                Network &amp; VPN
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Account+Access${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Account Access' ? 'active' : ''}">
                <i class="fas fa-user-lock"></i>
                Account Access
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Software${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Software' ? 'active' : ''}">
                <i class="fas fa-laptop-code"></i>
                Software
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Hardware${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Hardware' ? 'active' : ''}">
                <i class="fas fa-desktop"></i>
                Hardware
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Security${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Security' ? 'active' : ''}">
                <i class="fas fa-shield-alt"></i>
                Security
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=Email+%26+Communication${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'Email & Communication' ? 'active' : ''}">
                <i class="fas fa-envelope"></i>
                Email &amp; Comms
            </a>

            <a href="${pageContext.request.contextPath}/KnowledgeBase?cat=General${not empty searchKeyword ? '&q='.concat(searchKeyword) : ''}"
               class="kb-cat-link ${selectedCategory == 'General' ? 'active' : ''}">
                <i class="fas fa-question-circle"></i>
                General
            </a>
        </nav>

        <!-- Articles Grid -->
        <section class="kb-articles-section">
            <div class="kb-section-header">
                <h2 class="kb-section-title">
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            Search results for: "${fn:escapeXml(searchKeyword)}"
                        </c:when>
                        <c:when test="${selectedCategory != 'all' && not empty selectedCategory}">
                            ${selectedCategory}
                        </c:when>
                        <c:otherwise>
                            All Articles
                        </c:otherwise>
                    </c:choose>
                </h2>
                <span class="kb-result-count">${fn:length(articles)} result(s)</span>
            </div>

            <div class="kb-articles-grid" id="articlesGrid">
                <c:choose>
                    <c:when test="${not empty articles}">
                        <c:forEach var="article" items="${articles}" varStatus="loop">
                            <c:set var="catLower" value="${fn:toLowerCase(article.category)}" />

                            <!-- Assign icon and color class based on category - use catLower for case-insensitive matching -->
                            <c:set var="iconClass" value="fas fa-file-alt" />
                            <c:set var="iconBgClass" value="icon-bg-blue" />

                            <c:if test="${fn:contains(catLower, 'network') || fn:contains(catLower, 'vpn')}">
                                <c:set var="iconClass" value="fas fa-wifi" />
                                <c:set var="iconBgClass" value="icon-bg-blue" />
                            </c:if>
                            <c:if test="${fn:contains(catLower, 'account') || fn:contains(catLower, 'password')}">
                                <c:set var="iconClass" value="fas fa-user-lock" />
                                <c:set var="iconBgClass" value="icon-bg-purple" />
                            </c:if>
                            <c:if test="${fn:contains(catLower, 'software')}">
                                <c:set var="iconClass" value="fas fa-laptop-code" />
                                <c:set var="iconBgClass" value="icon-bg-teal" />
                            </c:if>
                            <c:if test="${fn:contains(catLower, 'hardware')}">
                                <c:set var="iconClass" value="fas fa-desktop" />
                                <c:set var="iconBgClass" value="icon-bg-amber" />
                            </c:if>
                            <c:if test="${fn:contains(catLower, 'security')}">
                                <c:set var="iconClass" value="fas fa-shield-alt" />
                                <c:set var="iconBgClass" value="icon-bg-rose" />
                            </c:if>
                            <c:if test="${fn:contains(catLower, 'email') || fn:contains(catLower, 'communication')}">
                                <c:set var="iconClass" value="fas fa-envelope" />
                                <c:set var="iconBgClass" value="icon-bg-green" />
                            </c:if>

                            <div class="kb-article-card" id="article-${article.id}">
                                <!-- Card Header -->
                                <div class="kb-article-header" onclick="toggleArticle(${article.id})">
                                    <div class="kb-article-icon-wrap ${iconBgClass}">
                                        <i class="${iconClass}"></i>
                                    </div>
                                    <div class="kb-article-meta">
                                        <div class="kb-article-category">${article.category}</div>
                                        <div class="kb-article-title">${fn:escapeXml(article.title)}</div>
                                    </div>
                                </div>

                                <!-- Preview Text -->
                                <div class="kb-article-preview" onclick="toggleArticle(${article.id})">
                                    <c:set var="previewContent" value="${article.content}" />
                                    <c:choose>
                                        <c:when test="${fn:length(previewContent) > 120}">
                                            ${fn:escapeXml(fn:substring(previewContent, 0, 120))}...
                                        </c:when>
                                        <c:otherwise>
                                            ${fn:escapeXml(previewContent)}
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Expandable Body -->
                                <div class="kb-article-body" id="body-${article.id}">
                                    <div class="kb-article-body-inner">
                                        <c:set var="rawContent" value="${article.content}" />
                                        <div class="kb-article-plain-content">${fn:escapeXml(rawContent)}</div>
                                    </div>

                                    <!-- Admin Delete Bar -->
                                    <c:if test="${sessionScope.role == 'Admin'}">
                                        <div class="kb-article-admin-bar">
                                            <form action="${pageContext.request.contextPath}/KnowledgeBase" method="POST"
                                                  onsubmit="return confirm('Remove this article from the Knowledge Base?');">
                                                <input type="hidden" name="action" value="deleteArticle">
                                                <input type="hidden" name="articleId" value="${article.id}">
                                                <button type="submit" class="btn-delete-article">
                                                    <i class="fas fa-trash-alt"></i> Remove Article
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Footer -->
                                <div class="kb-article-footer">
                                    <button class="kb-read-more-btn" onclick="toggleArticle(${article.id})" id="readbtn-${article.id}">
                                        <span>Read Article</span>
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                    <span class="kb-article-date">
                                        <c:if test="${not empty article.createdAt}">
                                            <fmt:formatDate value="${article.createdAt}" pattern="MMM d, yyyy"/>
                                        </c:if>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="kb-empty-state">
                            <div class="kb-empty-icon">
                                <i class="fas fa-search"></i>
                            </div>
                            <div class="kb-empty-title">No articles found</div>
                            <p class="kb-empty-text">
                                <c:choose>
                                    <c:when test="${not empty searchKeyword}">
                                        No articles match your search for "<strong>${fn:escapeXml(searchKeyword)}</strong>".
                                        Try different keywords or <a href="${pageContext.request.contextPath}/KnowledgeBase" style="color:var(--primary);">browse all articles</a>.
                                    </c:when>
                                    <c:otherwise>
                                        No articles available in this category yet.
                                        <c:if test="${sessionScope.role == 'Admin'}">
                                            <a href="#" onclick="openAddArticleModal(); return false;" style="color:var(--primary);">Add the first article.</a>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>

    <!-- Add Article Modal (Admin Only) -->
    <c:if test="${sessionScope.role == 'Admin'}">
        <div id="addArticleModal" class="modal-overlay">
            <div class="modal-box">
                <div class="modal-header">
                    <h2><i class="fas fa-plus-circle" style="color:var(--primary); margin-right:8px;"></i>Add Knowledge Base Article</h2>
                    <button type="button" class="modal-close-btn" onclick="closeAddArticleModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/KnowledgeBase" method="POST">
                    <input type="hidden" name="action" value="addArticle">
                    <div class="modal-body">

                        <div style="margin-bottom: 16px;">
                            <label class="form-label" for="articleTitle">Article Title</label>
                            <input type="text" id="articleTitle" name="articleTitle" class="form-field"
                                   placeholder="e.g. How to Connect to Corporate VPN" required>
                        </div>

                        <div style="margin-bottom: 16px;">
                            <label class="form-label" for="articleCategory">Category</label>
                            <select id="articleCategory" name="articleCategory" class="form-field" required>
                                <option value="">Select a category</option>
                                <option value="Network & VPN">Network &amp; VPN</option>
                                <option value="Account Access">Account Access</option>
                                <option value="Software">Software</option>
                                <option value="Hardware">Hardware</option>
                                <option value="Security">Security</option>
                                <option value="Email & Communication">Email &amp; Communication</option>
                                <option value="General">General</option>
                            </select>
                        </div>

                        <div>
                            <label class="form-label" for="articleContent">Article Content</label>
                            <textarea id="articleContent" name="articleContent" class="form-field" rows="7"
                                      placeholder="Write the article content. Use numbered steps for instructions (e.g. 1. Open... 2. Click...)" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-modal-cancel" onclick="closeAddArticleModal()">Cancel</button>
                        <button type="submit" class="btn-modal-submit">
                            <i class="fas fa-save"></i> Publish Article
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <script>
        // Toggle article expand/collapse
        function toggleArticle(id) {
            let card = document.getElementById('article-' + id);
            let body = document.getElementById('body-' + id);
            let btn = document.getElementById('readbtn-' + id);

            if (!body) return;

            let isOpen = body.classList.contains('open');

            // Close all others
            document.querySelectorAll('.kb-article-body').forEach(b => b.classList.remove('open'));
            document.querySelectorAll('.kb-article-card').forEach(c => c.classList.remove('expanded'));
            document.querySelectorAll('.kb-read-more-btn').forEach(b => {
                b.innerHTML = '<span>Read Article</span><i class="fas fa-chevron-right"></i>';
            });

            if (!isOpen) {
                body.classList.add('open');
                card.classList.add('expanded');
                if (btn) btn.innerHTML = '<span>Close Article</span><i class="fas fa-chevron-up"></i>';
                card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        }

        // Modal management
        function openAddArticleModal() {
            let modal = document.getElementById('addArticleModal');
            if (modal) modal.classList.add('active');
        }

        function closeAddArticleModal() {
            let modal = document.getElementById('addArticleModal');
            if (modal) modal.classList.remove('active');
        }

        // Close modal on backdrop click
        window.onclick = function(event) {
            let modal = document.getElementById('addArticleModal');
            if (modal && event.target === modal) {
                closeAddArticleModal();
            }
        };

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeAddArticleModal();
        });

        // Auto-expand if only one result
        window.addEventListener('DOMContentLoaded', function() {
            let cards = document.querySelectorAll('.kb-article-card');
            if (cards.length === 1) {
                let firstId = cards[0].id.replace('article-', '');
                if (firstId) toggleArticle(parseInt(firstId));
            }
        });
    </script>

</body>
</html>
