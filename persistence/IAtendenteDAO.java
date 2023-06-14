package com.les.healthworks.persistence;

import java.sql.SQLException;
import java.util.List;

import com.les.healthworks.model.Consulta;
import com.les.healthworks.model.Paciente;
import com.les.healthworks.model.Prontuario;

public interface IAtendenteDAO {
	public String cadastraPaciente(Paciente p) throws SQLException, ClassNotFoundException;
	public String editaPaciente(Paciente p) throws SQLException, ClassNotFoundException;
	public String excluiPaciente(Paciente p) throws SQLException, ClassNotFoundException;
	public Paciente pesquisaPaciente(Paciente p) throws SQLException, ClassNotFoundException;
	public List<Paciente> listaPacientes() throws SQLException, ClassNotFoundException;
	 
	public String cadastraProntuario(Prontuario pro) throws SQLException, ClassNotFoundException;
	public String editaProntuario(Prontuario pro) throws SQLException, ClassNotFoundException;
	public String excluiProntuario(Prontuario pro) throws SQLException, ClassNotFoundException;
	public Prontuario pesquisaProntuario(Prontuario pro) throws SQLException, ClassNotFoundException;
	public List<Prontuario>listaProntuarios() throws SQLException, ClassNotFoundException;
	 
	public String cadastraConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public String editaConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public String excluiConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public Consulta pesquisaConsulta(Consulta co) throws SQLException, ClassNotFoundException;
	public List<Consulta> listaConsultas() throws SQLException, ClassNotFoundException;
}
