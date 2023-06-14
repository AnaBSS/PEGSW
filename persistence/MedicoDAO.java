package com.les.healthworks.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.les.healthworks.model.Consulta;
import com.les.healthworks.model.Prontuario;

public class MedicoDAO implements IMedicoDAO{
	
	@Autowired
	GenericDAO gDao;

	@Override
	public String editaProntuario(String op, Prontuario pro) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_editar_prontuario(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, op);
		cs.setInt(2, pro.getCod());
		cs.setString(3, pro.getDiagnostico());
		cs.setString(4, pro.getMedico());
		cs.setString(5, pro.getPaciente());
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		
		cs.close();
		c.close();
		
		return saida;
	}

	@Override
	public Consulta pesquisaConsulta(Consulta co) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT data, hora, paciente FROM fn_pesquisarconsultasmedico(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, co.getPaciente());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			co.setData(rs.getDate("data"));
			co.setHora(rs.getTime("hora"));
			co.setPaciente(rs.getString("paciente"));
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
		String sql = "SELECT data, hora, paciente FROM fn_listarconsultasmedico()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Consulta co = new Consulta();
			co.setData(rs.getDate("data"));
			co.setHora(rs.getTime("hora"));
			co.setPaciente(rs.getString("paciente"));
			
			consulta.add(co);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return consulta;
	}

}
