package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Atendente;
import model.Cargo;
import model.Especialidade;
import model.Medico;

public interface IGestorDAO {
	 public void cadastraAtendente(Atendente a) throws SQLException;
	 public void editaAtendente(Atendente a) throws SQLException;
	 public void excluiAtendente(Atendente a) throws SQLException;
	 public Atendente pesquisaAtendente(Atendente a) throws SQLException;
	 public List<Atendente> listaAtendentes() throws SQLException;
	 
	 public void cadastraMedico(Medico m) throws SQLException;
	 public void editaMedico(Medico m) throws SQLException;
	 public void excluiMedico(Medico m) throws SQLException;
	 public Medico pesquisaMedico(Medico m) throws SQLException;
	 public List<Medico>listaMedicos() throws SQLException;
	 
	 public void cadastraEspecialidade(Especialidade e) throws SQLException;
	 public void editaEspecialidade(Especialidade e) throws SQLException;
	 public void excluiEspecialidade(Especialidade e) throws SQLException;
	 public Especialidade pesquisaEspecialidade(Especialidade e) throws SQLException;
	 public List<Especialidade> listaEspecialidades() throws SQLException;
	 
	 public Cargo getCargo(Cargo c) throws SQLException;
}
