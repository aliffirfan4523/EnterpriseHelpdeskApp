/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.helpdesk.domain.meta;

import com.helpdesk.domain.core.Ticket;
import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author aliff
 */
@Entity
@Table(name = "tags")
public class Tag implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(length = 45)
    private String name;

    @ManyToMany(mappedBy = "tags")
    private List<Ticket> tickets;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Ticket> getTickets() {
        return tickets;
    }

    public void setTickets(List<Ticket> tickets) {
        this.tickets = tickets;
    }

    
}