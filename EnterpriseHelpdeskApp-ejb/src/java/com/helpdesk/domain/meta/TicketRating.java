package com.helpdesk.domain.meta;

import com.helpdesk.domain.core.Ticket;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "ticket_ratings")
public class TicketRating implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_id", nullable = false, unique = true)
    private Ticket ticket;

    @Column(name = "rating", nullable = false)
    private int rating; // 1 to 5 stars

    @Lob
    @Column(name = "feedback")
    private String feedback;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "rated_at")
    private Date ratedAt;

    public TicketRating() {
        this.ratedAt = new Date();
    }

    public TicketRating(Ticket ticket, int rating, String feedback) {
        this.ticket = ticket;
        this.rating = rating;
        this.feedback = feedback;
        this.ratedAt = new Date();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Ticket getTicket() { return ticket; }
    public void setTicket(Ticket ticket) { this.ticket = ticket; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public Date getRatedAt() { return ratedAt; }
    public void setRatedAt(Date ratedAt) { this.ratedAt = ratedAt; }
}
