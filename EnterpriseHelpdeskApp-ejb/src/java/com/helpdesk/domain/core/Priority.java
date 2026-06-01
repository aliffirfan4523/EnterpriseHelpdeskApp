/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.helpdesk.domain.core;

import javax.persistence.*;
import java.io.Serializable;

/**
 *
 * @author aliff
 */
@Entity
@Table(name = "priorities")
public class Priority implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "level_name", length = 20)
    private String levelName;

    @Column(name = "resolve_hours")
    private int resolveHours;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLevelName() {
        return levelName;
    }

    public void setLevelName(String levelName) {
        this.levelName = levelName;
    }

    public int getResolveHours() {
        return resolveHours;
    }

    public void setResolveHours(int resolveHours) {
        this.resolveHours = resolveHours;
    }

    
}