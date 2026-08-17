package com.helpdesk.web;

import com.helpdesk.domain.meta.Article;
import com.helpdesk.ejb.TicketManagerBean;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "KnowledgeBaseServlet", urlPatterns = {"/KnowledgeBase"})
public class KnowledgeBaseServlet extends HttpServlet {

    @EJB
    private TicketManagerBean ticketManager;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String keyword = request.getParameter("q");
        String category = request.getParameter("cat");

        List<Article> articles = ticketManager.searchArticles(keyword, category);
        request.setAttribute("articles", articles);
        request.setAttribute("selectedCategory", category != null ? category : "all");
        request.setAttribute("searchKeyword", keyword != null ? keyword : "");

        request.getRequestDispatcher("/knowledge-base.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/KnowledgeBase");
            return;
        }

        String action = request.getParameter("action");
        Integer authorId = (Integer) session.getAttribute("userId");

        if ("addArticle".equals(action)) {
            String title = request.getParameter("articleTitle");
            String category = request.getParameter("articleCategory");
            String content = request.getParameter("articleContent");

            if (title != null && !title.trim().isEmpty()
                    && category != null && !category.trim().isEmpty()
                    && content != null && !content.trim().isEmpty()) {
                ticketManager.addArticle(title.trim(), category.trim(), content.trim(), authorId);
            }
            response.sendRedirect(request.getContextPath() + "/KnowledgeBase?added=true");

        } else if ("deleteArticle".equals(action)) {
            try {
                int articleId = Integer.parseInt(request.getParameter("articleId"));
                ticketManager.deleteArticle(articleId);
            } catch (NumberFormatException e) {
                // ignore malformed ID
            }
            response.sendRedirect(request.getContextPath() + "/KnowledgeBase?deleted=true");

        } else {
            response.sendRedirect(request.getContextPath() + "/KnowledgeBase");
        }
    }
}
