package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Cargo;
import model.Consulta;
import model.Especialidade;
import model.Paciente;
import model.Prontuario;

public interface IMedicoDAO {
	public Paciente pesquisarPaciente(Paciente pa) throws SQLException;
	public void editarProntuario(Prontuario pro) throws SQLException;
	public List<Consulta> listaConsulta() throws SQLException;
	public Cargo getCargo(Cargo c) throws SQLException;
	public Especialidade getEspecialidade(Especialidade e) throws SQLException;    
}
