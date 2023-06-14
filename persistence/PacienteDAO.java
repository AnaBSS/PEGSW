package com.les.healthworks.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.les.healthworks.model.Consulta;

public class PacienteDAO implements IPacienteDAO{
	
	@Autowired
	GenericDAO gDao;

	@Override
	public Consulta pesquisaConsulta(Consulta co) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT data, hora, medico, especialidade FROM fn_pacientepesquisaconsultas(?,?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, co.getPaciente());
		ps.setDate(2, co.getData());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			co.setData(rs.getDate("data"));
			co.setHora(rs.getTime("hora"));
			co.setMedico(rs.getString("medico"));
			co.setEspecialidade(rs.getInt("especialidade"));
		}
		rs.close();
		ps.close();
		c.close();
		return co;
	}

	@Override
	public List<Consulta> listaConsultas() throws SQLException, ClassNotFoundException {
		List<Consulta> consulta = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT data, hora, medico, especialidade FROM fn_pacientelistaconsultas()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Consulta co = new Consulta();
			co.setData(rs.getDate("data"));
			co.setHora(rs.getTime("hora"));
			co.setMedico(rs.getString("medico"));
			co.setEspecialidade(rs.getInt("especialidade"));
			
			consulta.add(co);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return consulta;
	}

}
