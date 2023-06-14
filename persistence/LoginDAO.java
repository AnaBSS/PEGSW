package com.les.healthworks.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.les.healthworks.model.Usuario;

@Repository
public class LoginDAO {
	
	@Autowired
	GenericDAO gDao;
	
	public Usuario getLogin(String email, String senha) throws ClassNotFoundException, SQLException {
		Usuario u = new Usuario();

        Connection c = gDao.getConnection();
        String sql = "SELECT tipo FROM fn_validaLogin(?,?)";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setString(1, email);
        ps.setString(2, senha);
        ResultSet rs = ps.executeQuery();

        try{
        	while (rs.next()) {
        		u.setEmail(email);
                u.setSenha(senha);
                u.setTipo(rs.getString("tipo"));
        	}
        	
        	rs.close();
        	ps.close();
        	c.close();
            
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }

        return u;
	}
	
}
