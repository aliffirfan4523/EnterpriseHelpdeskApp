package com.helpdesk.web;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Filter to optimize page load speeds by setting Cache-Control headers 
 * for static assets (CSS, JS, images, fonts).
 */
@WebFilter(filterName = "CacheControlFilter", urlPatterns = {"/style/*", "*.css", "*.js", "*.png", "*.jpg", "*.svg", "*.woff2"})
public class CacheControlFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        String uri = httpRequest.getRequestURI();
        
        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg")) {
            // Cache static assets for 24 hours in browser
            httpResponse.setHeader("Cache-Control", "public, max-age=86400, must-revalidate");
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
