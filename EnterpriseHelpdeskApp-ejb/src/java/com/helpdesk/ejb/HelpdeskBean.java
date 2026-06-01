/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/J2EE/EJB30/StatelessEjbClass.java to edit this template
 */
package com.helpdesk.ejb;

import javax.ejb.Stateless;
import java.util.Calendar;
import java.util.Date;
import javax.ejb.LocalBean;


/**
 *
 * @author aliff
 */
@Stateless
@LocalBean
public class HelpdeskBean {

    /**
     * Calculates the exact deadline for a ticket based on its priority level.
     * * @param createdDate The timestamp when the ticket was submitted.
     * @param resolveHours The allowed hours to resolve the issue (from the database).
     * @return The calculated deadline Date.
     */
    public Date calculateDeadline(Date createdDate, int resolveHours) {
        if (createdDate == null || resolveHours <= 0) {
            return createdDate; // Return original if data is invalid
        }
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(createdDate);
        cal.add(Calendar.HOUR, resolveHours); // Adds the SLA hours to the creation time
        
        return cal.getTime();
    }
}
