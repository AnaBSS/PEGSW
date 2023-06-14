package com.les.healthworks.persistence;

import java.sql.SQLException;
import java.util.List;

import com.les.healthworks.model.Consulta;
import com.les.healthworks.model.Prontuario;

public interface IMedicoDAO {
	public String editaProntuario(String op, Prontuario pro) throws SQLException, ClassNotFoundException;
	public Consulta pesquisaConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public List<Consulta> listaConsultas() throws SQLException, ClassNotFoundException;
}
