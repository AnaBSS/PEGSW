package persistence;

import java.sql.SQLException;
import java.util.List;

import model.Medico;
import model.Prontuario;
import model.Consulta;


public interface IProntuarioDAO {
	public Prontuario listaMedicoProntuario(Medico m) throws SQLException;
    public List<Consulta> getConsultas() throws SQLException;
}
