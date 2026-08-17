/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.helpdesk.domain.core;

import com.helpdesk.domain.meta.Comment;
import com.helpdesk.domain.meta.Tag;
import com.helpdesk.domain.meta.TicketRating;
import com.helpdesk.domain.meta.TicketAuditLog;
import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author aliff
 */
@Entity
@Table(name = "tickets")
public class Ticket implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(length = 100)
    private String title;

    @Lob
    private String description;

    @Column(length = 20)
    private String status;

    @Column(length = 50)
    private String category = "General Support";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_created", insertable = false, updatable = false)
    private Date dateCreated;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "priority_id", nullable = false)
    private Priority priority;

    @ManyToOne
    @JoinColumn(name = "assigned_to")
    private User assignedTo;

    @OneToMany(mappedBy = "ticket", cascade = CascadeType.ALL)
    private List<Comment> comments;

    @OneToOne(mappedBy = "ticket", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private TicketRating rating;

    @OneToMany(mappedBy = "ticket", cascade = CascadeType.ALL)
    @OrderBy("loggedAt DESC")
    private List<TicketAuditLog> auditLogs;

    // Many-To-Many relationship with tags
    @ManyToMany
    @JoinTable(
        name = "ticket_tags",
        joinColumns = @JoinColumn(name = "ticket_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<Tag> tags;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategory() {
        return category != null ? category : "General Support";
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Priority getPriority() {
        return priority;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
    }

    public User getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(User assignedTo) {
        this.assignedTo = assignedTo;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public TicketRating getRating() {
        return rating;
    }

    public void setRating(TicketRating rating) {
        this.rating = rating;
    }

    public List<TicketAuditLog> getAuditLogs() {
        return auditLogs;
    }

    public void setAuditLogs(List<TicketAuditLog> auditLogs) {
        this.auditLogs = auditLogs;
    }
}
