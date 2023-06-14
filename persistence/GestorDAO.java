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
import org.springframework.stereotype.Repository;

import com.les.healthworks.model.Atendente;
import com.les.healthworks.model.Especialidade;
import com.les.healthworks.model.Medico;

@Repository
public class GestorDAO implements IGestorDAO{
	
	@Autowired
	GenericDAO gDao;
	
	private String manterAtendente(String op, Atendente atendente) throws ClassNotFoundException, SQLException{
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_atendente(?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, op);
		cs.setString(2, atendente.getCpf());
		cs.setString(3, atendente.getNome());
		cs.setString(4, atendente.getCargo());
		cs.setString(5, atendente.getEmail());
		cs.setString(6, atendente.getTelefone());
		cs.setString(7, atendente.getSenha());
		cs.registerOutParameter(8, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(8);
		
		cs.close();
		c.close();
		
		return saida;
		
	}

	@Override
	public String cadastraAtendente(Atendente a) throws SQLException, ClassNotFoundException {
		String saida = manterAtendente("I", a);
		return saida;
	}

	@Override
	public String editaAtendente(Atendente a) throws SQLException, ClassNotFoundException {
		String saida = manterAtendente("U", a);
		return saida;
	}

	@Override
	public String excluiAtendente(Atendente a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_atendente(?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setString(2, a.getCpf());
		cs.setNull(3, Types.VARCHAR);
		cs.setNull(4, Types.CHAR);
		cs.setString(5, a.getEmail());
		cs.setNull(6, Types.CHAR);
		cs.setNull(7, Types.VARCHAR);
		cs.registerOutParameter(8, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(8);
		
		cs.close();
		c.close();
		
		return saida;
	}

	@Override
	public Atendente pesquisaAtendente(Atendente a) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, telefone FROM fn_pesquisaratendente(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, a.getCpf());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			a.setNome(rs.getString("nome"));
			a.setEmail(rs.getString("email"));
			a.setTelefone(rs.getString("telefone"));
		}
		rs.close();
		ps.close();
		c.close();
		return a;
	}

	@Override
	public List<Atendente> listaAtendentes() throws SQLException, ClassNotFoundException {
		List<Atendente> atendente = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, email, telefone FROM fn_listaratendente()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Atendente a = new Atendente();
			a.setCpf(rs.getString("cpf"));
			a.setNome(rs.getString("nome"));
			a.setEmail(rs.getString("email"));
			a.setTelefone(rs.getString("telefone"));
			
			atendente.add(a);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return atendente;
	}
	
	private String manterMedico(String op, Medico medico) throws ClassNotFoundException, SQLException{
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_medico(?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, op);
		cs.setString(2, medico.getCpf());
		cs.setString(3, medico.getNome());
		cs.setString(4, medico.getCrm());
		cs.setString(5, medico.getCargo());
		cs.setInt(6, medico.getEspecialidade());
		cs.setString(7, medico.getEmail());
		cs.setString(8, medico.getTelefone());
		cs.setString(9, medico.getSenha());
		cs.registerOutParameter(10, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(10);
		
		cs.close();
		c.close();
		
		return saida;
		
	}

	@Override
	public String cadastraMedico(Medico m) throws SQLException, ClassNotFoundException {
		String saida = manterMedico("I", m);
		return saida;
	}

	@Override
	public String editaMedico(Medico m) throws SQLException, ClassNotFoundException {
		String saida = manterMedico("U", m);
		return saida;
	}

	@Override
	public String excluiMedico(Medico m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_medico(?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setNull(2, Types.CHAR);
		cs.setNull(3, Types.VARCHAR);
		cs.setString(4, m.getCrm());
		cs.setNull(5, Types.CHAR);
		cs.setNull(6, Types.INTEGER);
		cs.setString(7, m.getEmail());
		cs.setNull(8, Types.CHAR);
		cs.setNull(9, Types.VARCHAR);
		cs.registerOutParameter(10, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(10);
		
		cs.close();
		c.close();
		
		return saida;
	}

	@Override
	public Medico pesquisaMedico(Medico m) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, crm, especialidade, email, telefone FROM fn_pesquisarmedico(?)";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, m.getCrm());
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			m.setNome(rs.getString("nome"));
			m.setEspecialidade(rs.getInt("especialidade"));
			m.setEmail(rs.getString("email"));
			m.setTelefone(rs.getString("telefone"));
		}
		rs.close();
		ps.close();
		c.close();
		return m;
	}

	@Override
	public List<Medico> listaMedicos() throws SQLException, ClassNotFoundException {
		List<Medico> medico = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cpf, nome, crm, especialidade, email, telefone FROM fn_listarmedico()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		
		while(rs.next()) {
			Medico m = new Medico();
			m.setCpf(rs.getString("cpf"));
			m.setNome(rs.getString("nome"));
			m.setCrm(rs.getString("crm"));
			m.setEspecialidade(rs.getInt("especialidade"));
			m.setEmail(rs.getString("email"));
			m.setTelefone(rs.getString("telefone"));
			
			medico.add(m);
		}
		
		rs.close();
		ps.close();
		c.close();
		
		return medico;
	}
	

	@Override
	public String cadastraEspecialidade(Especialidade e) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String editaEspecialidade(Especialidade e) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String excluiEspecialidade(Especialidade e) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Especialidade pesquisaEspecialidade(Especialidade e) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Especialidade> listaEspecialidades() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	
}
