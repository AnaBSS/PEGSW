package com.les.healthworks.persistence;

import java.sql.SQLException;
import java.util.List;

import com.les.healthworks.model.Consulta;

public interface IPacienteDAO {
	public Consulta pesquisaConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public List<Consulta> listaConsultas() throws SQLException, ClassNotFoundException;
}
