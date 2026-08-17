package com.helpdesk.domain.meta;

import com.helpdesk.domain.core.Ticket;
import com.helpdesk.domain.core.User;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "ticket_audit_logs")
public class TicketAuditLog implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "action", nullable = false, length = 100)
    private String action;

    @Lob
    @Column(name = "details")
    private String details;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "logged_at")
    private Date loggedAt;

    public TicketAuditLog() {
        this.loggedAt = new Date();
    }

    public TicketAuditLog(Ticket ticket, User user, String action, String details) {
        this.ticket = ticket;
        this.user = user;
        this.action = action;
        this.details = details;
        this.loggedAt = new Date();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Ticket getTicket() { return ticket; }
    public void setTicket(Ticket ticket) { this.ticket = ticket; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public Date getLoggedAt() { return loggedAt; }
    public void setLoggedAt(Date loggedAt) { this.loggedAt = loggedAt; }
}
