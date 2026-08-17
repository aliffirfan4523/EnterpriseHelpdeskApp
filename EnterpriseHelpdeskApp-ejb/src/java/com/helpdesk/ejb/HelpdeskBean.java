package com.helpdesk.ejb;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import javax.ejb.LocalBean;
import javax.ejb.Stateless;

@Stateless
@LocalBean
public class HelpdeskBean {

    /**
     * Calculates the exact deadline for a ticket based on its priority level.
     * @param createdDate The timestamp when the ticket was submitted.
     * @param resolveHours The allowed hours to resolve the issue (from the database).
     * @return The calculated deadline Date.
     */
    public Date calculateDeadline(Date createdDate, int resolveHours) {
        if (createdDate == null || resolveHours <= 0) {
            return createdDate;
        }
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(createdDate);
        cal.add(Calendar.HOUR, resolveHours);
        
        return cal.getTime();
    }

    /**
     * Calculates SLA status badge class and label.
     */
    public String getSlaStatus(Date createdDate, int resolveHours, String currentStatus) {
        if ("Closed".equalsIgnoreCase(currentStatus) || "Resolved".equalsIgnoreCase(currentStatus)) {
            return "RESOLVED";
        }
        Date deadline = calculateDeadline(createdDate, resolveHours);
        if (deadline == null) {
            return "ON_TRACK";
        }
        long now = System.currentTimeMillis();
        long diff = deadline.getTime() - now;
        if (diff < 0) {
            return "BREACHED";
        } else if (diff < TimeUnit.HOURS.toMillis(4)) {
            return "AT_RISK";
        } else {
            return "ON_TRACK";
        }
    }

    /**
     * Returns human readable remaining time or overdue duration.
     */
    public String getTimeRemainingFormatted(Date createdDate, int resolveHours, String currentStatus) {
        if ("Closed".equalsIgnoreCase(currentStatus) || "Resolved".equalsIgnoreCase(currentStatus)) {
            return "Completed";
        }
        Date deadline = calculateDeadline(createdDate, resolveHours);
        if (deadline == null) {
            return "N/A";
        }
        long now = System.currentTimeMillis();
        long diff = deadline.getTime() - now;
        boolean overdue = diff < 0;
        long absDiff = Math.abs(diff);

        long hours = TimeUnit.MILLISECONDS.toHours(absDiff);
        long minutes = TimeUnit.MILLISECONDS.toMinutes(absDiff) % 60;

        if (overdue) {
            if (hours > 24) {
                return (hours / 24) + "d overdue";
            }
            return hours + "h " + minutes + "m overdue";
        } else {
            if (hours > 24) {
                return (hours / 24) + "d left";
            }
            return hours + "h " + minutes + "m left";
        }
    }

    public String formatDateTime(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("MMM d, yyyy h:mm a");
        return sdf.format(date);
    }

    public String formatDateShort(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("MMM d, yyyy");
        return sdf.format(date);
    }
}

