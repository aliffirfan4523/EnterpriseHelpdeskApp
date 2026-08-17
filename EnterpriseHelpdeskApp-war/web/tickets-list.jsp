<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="java.util.List"%>
<%@page import="com.helpdesk.domain.core.Ticket"%>

<%
    List<Ticket> ticketsList = (List<Ticket>) request.getAttribute("tickets");
%>

<c:choose>
    <c:when test="${not empty tickets}">
        <table class="enterprise-table">
            <thead>
                <tr>
                    <th>Ticket ID</th>
                    <th>Issue Summary</th>
                    <th>Requester</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>SLA Deadline</th>
                    <th>Created</th>
                    <th style="text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody id="ticketTableBody">
                <c:forEach var="t" items="${tickets}">
                    <c:set var="priLower" value="${fn:toLowerCase(t.priority.levelName)}" />
                    <c:set var="statusLower" value="${fn:toLowerCase(t.status)}" />
                    <tr data-status="${statusLower}" 
                        data-priority="${priLower}" 
                        data-dept="${t.user.department != null ? fn:toLowerCase(t.user.department.name) : ''}">
                        
                        <!-- Ticket ID -->
                        <td class="ticket-id-cell">
                            #INC-${t.id}
                        </td>

                        <!-- Title -->
                        <td>
                            <a href="${pageContext.request.contextPath}/ViewTicket?ticketId=${t.id}" class="ticket-title-link" title="${t.title}">
                                ${t.title}
                            </a>
                            <c:if test="${not empty t.tags}">
                                <div style="display: flex; gap: 4px; margin-top: 4px;">
                                    <c:forEach var="tag" items="${t.tags}">
                                        <span style="font-size: 10px; background: #f1f5f9; color: #475569; padding: 1px 6px; border-radius: 4px; border: 1px solid #e2e8f0;">
                                            ${tag.name}
                                        </span>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </td>

                        <!-- Requester -->
                        <td>
                            <div class="user-badge-cell">
                                <div class="user-mini-avatar">
                                    <c:choose>
                                        <c:when test="${not empty t.user.name}">
                                            ${fn:toUpperCase(fn:substring(t.user.name, 0, 1))}
                                        </c:when>
                                        <c:otherwise>U</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="user-cell-info">
                                    <span class="user-cell-name">${t.user.name}</span>
                                    <span class="user-cell-dept">${t.user.department != null ? t.user.department.name : 'General Staff'}</span>
                                </div>
                            </div>
                        </td>

                        <!-- Priority -->
                        <td>
                            <c:choose>
                                <c:when test="${priLower == 'critical'}">
                                    <span class="badge badge-pri-critical"><i class="fas fa-radiation"></i> Critical</span>
                                </c:when>
                                <c:when test="${priLower == 'high'}">
                                    <span class="badge badge-pri-high"><i class="fas fa-arrow-up"></i> High</span>
                                </c:when>
                                <c:when test="${priLower == 'medium'}">
                                    <span class="badge badge-pri-medium"><i class="fas fa-minus"></i> Medium</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-pri-low"><i class="fas fa-arrow-down"></i> Low</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Status -->
                        <td>
                            <c:choose>
                                <c:when test="${statusLower == 'open'}">
                                    <span class="badge badge-status-open"><i class="fas fa-dot-circle"></i> Open</span>
                                </c:when>
                                <c:when test="${statusLower == 'in progress'}">
                                    <span class="badge badge-status-progress"><i class="fas fa-spinner fa-spin"></i> In Progress</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-status-closed"><i class="fas fa-check-circle"></i> ${t.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- SLA Deadline -->
                        <td>
                            <c:choose>
                                <c:when test="${not empty helpdeskBean && not empty t.dateCreated}">
                                    <c:set var="slaStat" value="${helpdeskBean.getSlaStatus(t.dateCreated, t.priority.resolveHours, t.status)}" />
                                    <c:set var="slaText" value="${helpdeskBean.getTimeRemainingFormatted(t.dateCreated, t.priority.resolveHours, t.status)}" />
                                    <c:choose>
                                        <c:when test="${slaStat == 'BREACHED'}">
                                            <span class="sla-badge breached"><i class="fas fa-exclamation-triangle"></i> ${slaText}</span>
                                        </c:when>
                                        <c:when test="${slaStat == 'AT_RISK'}">
                                            <span class="sla-badge at-risk"><i class="fas fa-hourglass-half"></i> ${slaText}</span>
                                        </c:when>
                                        <c:when test="${slaStat == 'RESOLVED'}">
                                            <span class="sla-badge resolved"><i class="fas fa-check"></i> Resolved</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="sla-badge on-track"><i class="fas fa-shield-alt"></i> ${slaText}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--text-muted); font-size: 12px;">Standard SLA</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <!-- Date Created -->
                        <td style="color: var(--text-muted); font-size: 12px; white-space: nowrap;">
                            <fmt:formatDate value="${t.dateCreated}" pattern="MMM d, yyyy h:mm a"/>
                        </td>

                        <!-- Action -->
                        <td style="text-align: right;">
                            <a href="${pageContext.request.contextPath}/ViewTicket?ticketId=${t.id}" class="btn-table-action">
                                <span>View</span>
                                <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <div style="padding: 60px 20px; text-align: center; color: var(--text-muted);">
            <div style="width: 56px; height: 56px; border-radius: 50%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; color: #94a3b8; font-size: 22px;">
                <i class="fas fa-inbox"></i>
            </div>
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text-primary); margin-bottom: 6px;">No Tickets Found</h3>
            <p style="font-size: 13px; max-width: 360px; margin: 0 auto;">There are currently no tickets matching your criteria or assigned to this view.</p>
        </div>
    </c:otherwise>
</c:choose>
