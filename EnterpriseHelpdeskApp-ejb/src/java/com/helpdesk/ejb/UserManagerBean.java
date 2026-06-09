package com.helpdesk.ejb;

import com.helpdesk.domain.core.User;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.nio.charset.StandardCharsets;
import java.util.List;
import com.helpdesk.domain.core.Department;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.nio.charset.StandardCharsets;

@Stateless
public class UserManagerBean {

    @PersistenceContext(unitName = "HelpdeskPU")
    private EntityManager em;

    // Method for Registration
    public void registerUser(User user) {
        // Hash the password before saving to the database
        user.setPassword(hashPassword(user.getPassword()));
        em.persist(user);
    }

    // Method for Login
    public User authenticate(String email, String password, String role) {
        try {
            // Hash the incoming password to compare with the hashed password in the DB
            String hashedPassword = hashPassword(password);
            
            String jpql = "SELECT u FROM User u WHERE u.email = :email AND u.password = :password AND u.role = :role";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("email", email);
            query.setParameter("password", hashedPassword);
            query.setParameter("role", role);
            
            return query.getSingleResult(); // Returns the User if found
        } catch (NoResultException e) {
            return null; // Return null if invalid credentials
        }
    }

    // Private Helper Method to Encrypt Passwords
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException ex) {
            throw new RuntimeException("Error encrypting password", ex);
        }
    }

    // Methods for Departments
    public List<Department> getAllDepartments() {
        return em.createQuery("SELECT d FROM Department d ORDER BY d.name ASC", Department.class).getResultList();
    }

    public Department findDepartmentById(int id) {
        return em.find(Department.class, id);
    }
}
