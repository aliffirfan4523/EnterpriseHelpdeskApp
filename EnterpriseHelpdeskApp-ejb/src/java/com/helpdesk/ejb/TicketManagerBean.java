package com.helpdesk.ejb;

import com.helpdesk.domain.core.Ticket;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class TicketManagerBean {

    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    public List<Ticket> getAllTicketsSortedByDate() {
        String jpql = "SELECT t FROM Ticket t ORDER BY t.dateCreated DESC";
        TypedQuery<Ticket> query = em.createQuery(jpql, Ticket.class);
        return query.getResultList();
    }

    public void updateTicketStatus(int ticketId, String newStatus) {
        Ticket ticket = em.find(Ticket.class, ticketId);
        if (ticket != null) {
            ticket.setStatus(newStatus);
            em.merge(ticket);
        }
    }
}
