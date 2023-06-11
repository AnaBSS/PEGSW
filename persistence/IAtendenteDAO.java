package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Paciente;
import model.Cargo;
import model.Consulta;
import model.Prontuario;

public interface IAtendenteDAO {
	 public void cadastraPaciente(Paciente p) throws SQLException;
	 public void editaPaciente(Paciente p) throws SQLException;
	 public void excluiPaciente(Paciente p) throws SQLException;
	 public Paciente pesquisaPaciente(Paciente p) throws SQLException;
	 public List<Paciente> listaPacientes() throws SQLException;
	 
	 public void cadastraProntuario(Prontuario pro) throws SQLException;
	 public void editaProntuario(Prontuario pro) throws SQLException;
	 public void excluiProntuario(Prontuario pro) throws SQLException;
	 public Prontuario pesquisaProntuario(Prontuario pro) throws SQLException;
	 public List<Prontuario>listaProntuarios() throws SQLException;
	 
	 public void cadastraConsulta(Consulta co) throws SQLException;
	 public void editaConsulta(Consulta co) throws SQLException;
	 public void excluiConsulta(Consulta co) throws SQLException;
	 public Consulta pesquisaConsulta(Consulta co) throws SQLException;
	 public List<Consulta> listaConsultas() throws SQLException;
	 
	 public Cargo getCargo(Cargo c) throws SQLException;
}
